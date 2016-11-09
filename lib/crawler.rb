require 'open-uri'

URL = 'http://www.lecker-ohne.de'

# The WebCrawler is a general focused crawler. It saves the URLs to single recipies which are visited by workers
class WebCrawler
  #require 'open-uri'

  def initialize(overview_url, menu_type)
    @url = overview_url
    @menu_type = menu_type
    @next_page
  end

  public

  def crawl
    url_already_exists = false

    urls = extract_child_nodes(@url)

    if urls.any?
      urls.each do |url|
        if Recipe.exists?(url: url)
          url_already_exists = true
        else
          call_worker(url)
        end
        call_worker(url)
      end
    end

    extract_next_page(@url)

    unless @next_page == "" || url_already_exists
      web_crawler = WebCrawler.new(@next_page, @menu_type)
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
    end
    unless @next_page == ""
      @next_page = URL + @next_page
    end
    @next_page
  end

  def call_worker(url)
    worker = Worker.new(url, @menu_type)
    worker.crawl
  end
end

# The Worker is called by the WebCrawler after it has collected all URLs leading to recipies from one page.
# The Worker extracts all important informations and stores them into a JSON-File.
class Worker
  #require 'open-uri'

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
    #recipe[:url] = @url
    #TODO needs to be sanitized
    recipe[:intolerances] = sanitizer.sanitize_intolerances(intolerances)
    recipe[:instructions] = sanitizer.sanitize_instructions(instructions)
    #TODO needs to be sanitized
    recipe[:allergies] = sanitizer.sanitize_allergies(allergies)
    recipe[:picture_url] = picture_url
    recipe[:menu_type] = @menu_type
    recipe[:url] = @url

    store_recipe(recipe)
  end

  def store_recipe(recipe)
    ingredients = recipe[:ingredients]
    allergies = recipe[:allergies]
    intolerances = recipe[:intolerances]

    # Allergies and Intolerances are saved both as allergies due to their similarity
    allergies << intolerances

    # recipe[:name == "Mandelwaffeln mit Brombeercreme" is needed because lecker-ohne has an wrong entry
    unless Recipe.exists?(url: recipe[:url]) || recipe[:name] == "Mandelwaffeln mit Brombeercreme" || recipe[:name] == "Chili vegetarisch" || recipe[:name] ==  "Zwiebelkuchen vegetarisch"
      Recipe.create(name: recipe[:name], url: recipe[:url], instructions: recipe[:instructions],
                    picture_url: recipe[:picture_url], menu_type: recipe[:menu_type])

      recipe_from_db = Recipe.where(url: recipe[:url]).first
      # is needed because somethimes there is an mistake on essen-ohne so that the recipe can't be saved
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
    ignore_words = ['Schreibe', 'Stück', 'Bund', 'Fett', 'Prise', 'Tk', 'El', 'Tl' 'TK', 'EL', 'TL']
    sanitized_array_of_ingredients = []

    array_of_ingredient_descriptions.each do |ingredient_description|
      ingredient_description.split(" ").each do |word|
        #some words contain a ',' at the end, which needs to be deleted
        word.chomp!(",")

        if word == 'Für'
          break
        end

        tb_ignored = false
        ignore_words.each do |ignore|
          if word.capitalize == ignore
            tb_ignored = !tb_ignored
            break
          end
        end

        if word == word.capitalize && word != 'El' && word != 'Tl' && !tb_ignored
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
      #puts intolerance
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


#crawler = WebCrawler.new("http://www.lecker-ohne.de/alle-rezepte?ka=1&titel=&field_rezeptzutaten_value=&items_per_page=60", "result.json", "dessert")
#crawler.extract_child_nodes("http://www.lecker-ohne.de/alle-rezepte?ka=1&titel=&field_rezeptzutaten_value=&items_per_page=60")
#puts "___________"
#crawler.extract_next_page("http://www.lecker-ohne.de/alle-rezepte?ka=1&titel=&field_rezeptzutaten_value=&items_per_page=60")

#worker = Worker.new('recipe_page.html', 'result.json', 'dessert')
#worker.get_recipe_information
#s = Sanitizer.new
##ing = [" 200g Salatgurke"," 150g Zucchini"," 75g grüne 2 Bund Paprika"," 1 Avocado"," je 1/2 Bund Blattpetersilie und Koriander"," 250ml Gemüsebrühe"," Salz, Pfeffer"," Für die Test Spieße:"," 250g Hähnchenbrust"," Salz, Chili"," 2 El Sesam"," 2 El Rapsöl"]
#intol = [" Diabetes"," Fructoseunverträglichkeit"," Laktoseintoleranz"," Nahrungsmittelallergien"," Rheuma"," Zöliakie, Sprue"]
##s.sanitize_ingredients(a)
#s.sanitize_intolerances(intol)

#all = [" ohne Kuhmilch"," ohne Soja"," ohne Ei"," ohne Weizen"]
#s.sanitize_allergies(all)


