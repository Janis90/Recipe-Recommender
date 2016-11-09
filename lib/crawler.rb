#require 'json'
#require 'rubygems'
#require 'nokogiri'
require 'open-uri'

URL = 'www.lecker-ohne.de'

#TODO page.html -> url
#TODO do not save the same recipe twice

# The WebCrawler is a general focused crawler. It saves the URLs to single recipies which are visited by workers
class WebCrawler

  def initialize(overview_url, result_file, menu_type)
    @url = overview_url
    @file = result_file
    @menu_type = menu_type
    @next_page
  end

  public

  def crawl

    urls = extract_child_nodes

    if urls.any?
      urls.each{ |url| call_worker(url) }
    end

    extract_next_page

    unless @next_page == ""
      web_crawler = WebCrawler.new(@next_page, @file, @menu_type)
      web_crawler.crawl
    end
  end

  private

  # Collects all URLs leading to recipies from a given URL.
  def extract_child_nodes
    urls = []
    first_link = true
    page = Nokogiri::HTML(open("page.html"))

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

  def extract_next_page
    page = Nokogiri::HTML(open("page.html"))
    @next_page = page.css('li.pager-next a')[0]['href']
    unless @next_page == ""
      @next_page = URL + @next_page
    end
  end

  def call_worker(url)
    worker = Worker.new(url, @result_file, @menu_type)
    worker.crawl
  end
end

# The Worker is called by the WebCrawler after it has collected all URLs leading to recipies from one page.
# The Worker extracts all important informations and stores them into a JSON-File.
class Worker

  def initialize(url, result_file, menu_type)
    @url = url
    @result_file = result_file
    @menu_type = menu_type
  end

  public

  def crawl
    #TODO
  end

  def get_recipe_information
    incredients = []
    intolerances = []
    instructions = []
    allergies = []

    page = Nokogiri::HTML(open("recipe_page.html"))
    name = page.css('h1.title')[0].text
    page.css('ul.field-rezeptzutaten li').each{ |incredient| incredients << incredient.text }
    page.css('div#node-rezept-full-group-infos div.field-taxonomy-vocabulary-3').each{ |intolerance| intolerances << intolerance.text }
    page.css('div.ds-1col p').each{ |instruction| instructions << instruction.text}
    page.css('ul.field-rezeptallergien li').each { |allergy| allergies << allergy.text }
    picture_url = page.css('div.field-rezeptbild img')[0]['src']

    create_and_store_recipe(name, incredients, intolerances, instructions, allergies, picture_url)
  end

  def create_and_store_recipe(name, incredients, intolerances, instructions, allergies, picture_url)
    recipe = {}
    sanitizer = Sanitizer.new
    recipe[:name] = name
    recipe[:incredients] = sanitizer.sanitize_ingredients(incredients)
    #recipe[:url] = @url
    #TODO needs to be sanitized
    recipe[:intolerances] = sanitizer.sanitize_intolerances(intolerances)
    recipe[:instructions] = instructions
    #TODO needs to be sanitized
    recipe[:allergies] = sanitizer.sanitize_allergies(allergies)
    recipe[:picture_url] = picture_url
    recipe[:menu_type] = @menu_type
    recipe[:url] = @url

    puts recipe
    #store_recipe_as_json(recipe)
  end

  def store_recipe_as_json(recipe)
    File.open(@result_file, 'a') do |file|
      file.write(recipe.to_json)
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
      sanitized_allergies << allergy[6, allergy.size-1]
    end

    sanitized_allergies
  end
end



#probably not needed
def run(overview_url, result_file, menu_type)
  #TODO perhaps clean result_file; perhaps w -> a
  open(result_file, 'w') { |f| f.puts "[" }
  crawler = Crawler.new(overview_url, result_file, menu_type)
  crawler.crawl
  #TODO delete last character from file
  File.open(filename, 'a') { |f| f.write "]"}
end

#crawler = WebCrawler.new("page.html", "result.json", "dessert")
#crawler.extract_next_page
#crawler.extract_next_page

worker = Worker.new('recipe_page.html', 'result.json', 'dessert')
worker.get_recipe_information
#s = Sanitizer.new
##ing = [" 200g Salatgurke"," 150g Zucchini"," 75g grüne 2 Bund Paprika"," 1 Avocado"," je 1/2 Bund Blattpetersilie und Koriander"," 250ml Gemüsebrühe"," Salz, Pfeffer"," Für die Test Spieße:"," 250g Hähnchenbrust"," Salz, Chili"," 2 El Sesam"," 2 El Rapsöl"]
#intol = [" Diabetes"," Fructoseunverträglichkeit"," Laktoseintoleranz"," Nahrungsmittelallergien"," Rheuma"," Zöliakie, Sprue"]
##s.sanitize_ingredients(a)
#s.sanitize_intolerances(intol)

#all = [" ohne Kuhmilch"," ohne Soja"," ohne Ei"," ohne Weizen"]
#s.sanitize_allergies(all)
