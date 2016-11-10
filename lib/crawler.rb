require 'open-uri'
require 'nokogiri'

URL = 'http://www.lecker-ohne.de'

# The WebCrawler is a general focused crawler. It saves the URLs to single recipies which are visited by workers
class WebCrawler
  def initialize(overview_url, menu_type)
    @url = overview_url
    @menu_type = menu_type
    @next_page
  end

  public

  def crawl
    urls = extract_child_nodes(@url)

    if urls.any?
      urls.each do |url|
        call_worker(url)
      end
    end

    extract_next_page(@url)

    puts @next_page
    unless @next_page == ""
      web_crawler = WebCrawler.new(@next_page, @menu_type)
      #In order to prevent the connection from being canceled
      sleep(30)
      web_crawler.crawl
    end
  end

  private

  # Collects all URLs leading to recipies from a given URL.
  def extract_child_nodes(url)
    urls = []
    first_link = true
    page = Nokogiri::HTML(open(url))

    page.css('div.view-content a').each{ |link|
      #div.view-content a contains of two links which lead to the same page
      #In order to avoid duplication, only the first link is selected
      if first_link
        urls << URL + link['href']
      end
      first_link = !first_link
    }
    urls
  end

  def extract_next_page(url)
    page = Nokogiri::HTML(open(url))
    unless page.css('li.pager-next a')[0].nil?
      @next_page = page.css('li.pager-next a')[0]['href']
      @next_page = URL + @next_page
    else
      @next_page = ""
    end
  end

  def call_worker(url)
    worker = Worker.new(url, @menu_type)
    worker.crawl
  end
end

# The Worker is called by the WebCrawler after it has collected all URLs leading to recipies from one page.
# The Worker extracts all important informations and stores them into a JSON-File.
class Worker
  def initialize(url, menu_type)
    @url = url
    @menu_type = menu_type
  end

  public

  def crawl
    get_recipe_information
  end

  private

  def get_recipe_information
    incredients = []
    intolerances = []
    instructions = []
    allergies = []

    #require 'open-uri'
    page = Nokogiri::HTML(open(@url))
    name = page.css('h1.title')[0].text
    page.css('ul.field-rezeptzutaten li').each{ |incredient| incredients << incredient.text }
    page.css('div#node-rezept-full-group-infos div.field-taxonomy-vocabulary-3').each{ |intolerance| intolerances << intolerance.text }
    page.css('div.ds-1col p').each{ |instruction| instructions << instruction.text}
    page.css('ul.field-rezeptallergien li').each { |allergy| allergies << allergy.text }
    #picture might not exist
    if page.css('div.field-rezeptbild img')[0].nil?
      #Platzhalter
      picture_url = 'http://www.brennholz-brandl.de/images/pictures/platzhalter-bild.jpg'
    else
      picture_url = page.css('div.field-rezeptbild img')[0]['src']
    end

    create_recipe(name, incredients, intolerances, instructions, allergies, picture_url)
  end

  def create_recipe(name, ingredients, intolerances, instructions, allergies, picture_url)
    recipe = {}
    sanitizer = Sanitizer.new
    recipe[:name] = name
    recipe[:ingredients] = sanitizer.sanitize_ingredients(ingredients)
    #TODO needs to be sanitized
    recipe[:intolerances] = sanitizer.sanitize_intolerances(intolerances)
    recipe[:instructions] = sanitizer.sanitize_instructions(instructions)
    #TODO needs to be sanitized
    recipe[:allergies] = sanitizer.sanitize_allergies(allergies)
    recipe[:picture_url] = picture_url
    recipe[:menu_type] = @menu_type
    recipe[:url] = @url
    puts recipe[:ingredients]

    store_recipe(recipe)
  end

  def store_recipe(recipe)
    ingredients = recipe[:ingredients]
    allergies = recipe[:allergies]
    intolerances = recipe[:intolerances]

    # Allergies and Intolerances are saved both as allergies due to their similarity
    allergies << intolerances

    unless Recipe.exists?(url: recipe[:url])
      Recipe.create(name: recipe[:name], url: recipe[:url], instructions: recipe[:instructions],
                    picture_url: recipe[:picture_url], menu_type: recipe[:menu_type])

      recipe_from_db = Recipe.where(url: recipe[:url]).first

      # is needed because sometimes there is an mistake on essen-ohne so that the recipe can't be saved (e.g. empty instructions)
      unless recipe_from_db.nil?
        ingredients.each do |ingredient|
          unless Ingredient.exists?(name: ingredient)
            Ingredient.create(name: ingredient)
          end
          ingredient_from_db = Ingredient.where(name: ingredient).first
          unless RecipeIngredient.exists?(recipe_id: recipe_from_db.id, ingredient_id: ingredient_from_db.id)
            RecipeIngredient.create(recipe_id: recipe_from_db.id, ingredient_id: ingredient_from_db.id )
          end
        end

        allergies.each do |allergy|
          if Allergy.exists?(name: allergy)
            allergy_from_db = Allergy.where(name: allergy).first
            unless RecipeAllergy.exists?(recipe_id: recipe_from_db.id, allergy_id: allergy_from_db.id )
              RecipeAllergy.create(recipe_id: recipe_from_db.id, allergy_id: allergy_from_db.id)
            end
          end
        end
      end
    end
  end
end

class Sanitizer
  #Sanitize ingredients gets an array with incedients
  #Incredients look like e.g. like '200 g Frischkäse (10% Fett)'
  #This function extracts only the main ingredient
  def sanitize_ingredients(array_of_ingredient_descriptions)
    #TODO to be completed
    ignore_words = %w(Scheibe Scheiben Stück Bund Fett Prise Tk El Tr Tl TK EL TL Pk Stk Doppelrahmstufe Dressing
                      Msp Pkt Tüte Bsp Typ Pck Stücke Deko Pr Priese Je Msp Beutel Stärke Tropfen Form Schale Abrieb
                      Dose Type Holzspieße Belieben Konserve Saft Kg Liter Kräuter Förmchen Deko Kerzen Kilo Blatt
                      L Pulver Geschmack Rinde Backen Stiele Stiel Pfanne Stein ½ Stange Braten Packung Pack Formen)
    sanitized_array_of_ingredients = []

    array_of_ingredient_descriptions.each do |ingredient_description|
      ingredient_description.split(" ").each do |word|
        tb_ignored = false

        #some words contain a ',' or another character at the end, which needs to be deleted
        word.chomp!(",")
        word.chomp!(";")
        word.chomp!(")")
        word.chomp!("/")
        word.chomp!("-")
        word.chomp!(".")
        # in case of '...'
        word.chomp!("..")
        word.chomp!("+")
        word.chomp!("*")
        word.chomp!("&")
        word.chomp!(":")
        word.chomp!(";")

        #In case of 'Für die ...:'
        if word == 'Für'
          break
        end


        ignore_words.each do |ignore|
          if word.upcase == ignore.upcase
            tb_ignored = !tb_ignored
            break
          end
        end

        if word == word.capitalize && !tb_ignored && word != ""
          unless word.start_with?('(') || word.start_with?(*('0' .. '9'))
            sanitized_array_of_ingredients << word
          end
        end
      end
    end
    sanitized_array_of_ingredients
  end

  def sanitize_intolerances(intolerances)
    possible_intolerances = ['Fructoseunverträglichkeit','Histamin-Intoleranz', 'Laktoseintoleranz', 'Vegan', 'Vegetarisch']
    sanitized_intolerances = []

    intolerances.each do |intolerance|
      #the crawled intolerances sometimes have a whitespace at the beginning
      intolerance.gsub!(/\s+/, '')

      possible_intolerances.each do |p_intolerance|
        if intolerance == p_intolerance
          sanitized_intolerances << intolerance
        end
      end
    end
    sanitized_intolerances
  end

  #possible allergies: 'Kuhmilch', 'Soja', 'Ei', 'Weizen'
  def sanitize_allergies(allergies)
    sanitized_allergies = []

    allergies.each do |allergy|
      sanitized_allergies << allergy[6, allergy.size-1] + "-Unverträglichkeit"
    end

    sanitized_allergies
  end

  def sanitize_instructions(instructions)
    merged_instructions = ""
    instructions.each do |instruction|
      merged_instructions += " " + instruction
    end
    merged_instructions
  end
end