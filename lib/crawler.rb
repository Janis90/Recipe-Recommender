require 'open-uri'
require 'nokogiri'

URL = 'http://www.lecker-ohne.de'

synonyms = {"Amarettini" => "Amaretto",
                      "Ananascheibe" => "Ananas",
                      "Ananassaft" => "Ananas",
                      "Apfelkompott" => "Apfel",
                      "Apfelmark" => "Apfel",
                      "Apfelmus" => "Apfel",
                      "Apfelpüree" => "Apfel",
                      "Apfelsaft" => "Apfel",
                      "Aprikosen" => "Aprikose",
                      "Aprikosenkompott" => "Aprikose",
                      "Auberginen" => "Aubergine",
                      "Backkakao" => "Kakao",
                      "Bananen" => "Banane",
                      "Bananensaft" => "Banane",
                      "Bananenstückchen" => "Banane",
                      "Bandnudeln" => "Nudeln",
                      "Basilikumblätter" => "Basilikum",
                      "Basmatireis" => "Reis",
                      "Beerenfrüchte" => "Beeren",
                      "Beerenobst" => "Beeren",
                      "Berglinsen" => "Linsen",
                      "Bergkäse" => "Käse",
                      "Bienenhonig" => "Honig",
                      "Birnen" => "Birne",
                      "Birnendicksaft" => "Birne",
                      "Birnenkompott" => "Birne",
                      "Birnensaft" => "Birne",
                      "Blattpetersilie" => "Petersilie",
                      "Blattsalat" => "Salat",
                      "Blattsalate" => "Salat",
                      "Blattspinat" => "Spinat",
                      "Bleichsellerie" => "Sellerie",
                      "Blutorangen" => "Blutorange",
                      "Blutorangensaft" => "Blutorange",
                      "Broccoli" => "Brokkoli",
                      "Brühpulver" => "Brühe",
                      "Brühwürfel" => "Brühe",
                      "Buchweizenmehl" => "Mehl",
                      "Butterfisch" => "Fisch",
                      "Butterkäse" => "Käse",
                      "Butternut" => "Kürbis",
                      "Camembert" => "Käse",
                      "Cannelloni" => "Nudeln",
                      "Canneloni" => "Nudeln",
                      "Chiliflocken" => "Chili",
                      "Chilisauce" => "Chili",
                      "Chilischote" => "Chili",
                      "Chilischoten" => "Chili",
                      "Chilli" => "Chili",
                      "Chillipulver" => "Chili",
                      "Chillisauce" => "Chili",
                      "Chillischote" => "Chili",
                      "Chillischoten" => "Chili",
                      "Chorizo" => "Wurst",
                      "Cocktailtomaten" => "Tomate",
                      "Cornichons" => "Gewürzgurke",
                      "Cranberrys" => "Cranberries",
                      "Currypaste" => "Curry",
                      "Currypulver" => "Curry",
                      "Dinkel" => "Mehl",
                      "Dinkelgrieß" => "Mehl",
                      "Dinkelmehl" => "Mehl",
                      "Diätmargarine" => "Margarine",
                      "Doppelrahmfrischkäse" => "Frischkäse",
                      "Dorade" => "Fisch",
                      "Doradenfilet" => "Fisch",
                      "Dorschfilet" => "Fisch",
                      "Dosenmais" => "Mais",
                      "Eidotter" => "Ei",
                      "Eier" => "Ei",
                      "Eiernudeln" => "Ei",
                      "Eigelb" => "Ei",
                      "Eigelbe" => "Ei",
                      "Eiklar" => "Ei",
                      "Eiweiß" => "Ei",
                      "Eiweiße" => "Ei",
                      "Eiernudeln" => "Nudeln",
                      "Eisbergsalat" => "Salat",
                      "Emmentaler" => "Käse",
                      "Endiviensalat" => "Salat",
                      "Erdbeeren" => "Erdbeere",
                      "Erdnussöl" => "Erdnuss",
                      "Erdnußöl" => "Erdnuss",
                      "Erdnüsse" => "Erdnuss",
                      "Falafelmehlmischung" => "Falafel",
                      "Feldsalat" => "Salat",
                      "Fenchelgrün" => "Fenchel",
                      "Fenchelknollen" => "Fenchel",
                      "Fenchelsamen" => "Fenchel",
                      "Feta" => "Käse",
                      "Fetakäse" => "Käse",
                      "Filoteigblätter" => "Filoteig",
                      "Fischfilet" => "Fisch",
                      "Fleischtomaten" => "Tomate",
                      "Frühlingszwiebeln" => "Frühlingszwiebel",
                      "Fusilli" => "Nudeln",
                      "Galiamelone" => "Melone",
                      "Gehacktes" => "Hackfleisch",
                      "Gelantine" => "Gelatine",
                      "Gemüsemais" => "Mais",
                      "Gemüsepaprika" => "Paprika",
                      "Getreideflockenmischung" => "Mehl",
                      "Glasnudeln" => "Nudeln",
                      "Gorgonzola" => "Käse",
                      "Gouda" => "Käse",
                      "Gouda,jung" => "Käse",
                      "Grapefruitsaft" => "Grapefruit",
                      "Haferdrink" => "Hafer",
                      "Haferflakes" => "Hafer",
                      "Haferflocken" => "Hafer",
                      "Haferkekse" => "Hafer",
                      "Haferkerne" => "Hafer",
                      "Halbfettmargarine" => "Margarine",
                      "Hartkäse" => "Käse",
                      "Haselnüsse" => "Haselnuss",
                      "Heidelbeeren" => "Heidelbeere",
                      "Hirseflocken" => "Hirse",
                      "Hokkaidokürbis" => "Kürbis",
                      "Honigmelone" => "Melone",
                      "Hähnchenbrust" => "Huhn",
                      "Hähnchenbrustfilet" => "Huhn",
                      "Hähnchenfilet" => "Huhn",
                      "Hörnchennudeln" => "Nudeln",
                      "Hühnchenbrustfilets" => "Huhn",
                      "Hühnerbrustfilet" => "Huhn",
                      "Hühnerei" => "Ei",
                      "Hühnereigelb" => "Ei",
                      "Hühnereiweiß" => "Ei",
                      "Hühnerschenkel" => "Huhn",
                      "Ingwerknolle" => "Ingwer",
                      "Ingwerpulver" => "Ingwer",
                      "Ingwerwurzel" => "Ingwer",
                      "Kabeljau" => "Fisch",
                      "Kabeljaufilet" => "Fisch",
                      "Kakaopulver" => "Kakao",
                      "Kalbsschnitzel" => "Kalb",
                      "Kardamom" => "Kardamon",
                      "Karotten" => "Karotte",
                      "Karottenwürfel" => "Karotte",
                      "Kartoffeln" => "Kartoffel",
                      "Kartoffelstärke" => "Kartoffel",
                      "Kartoffelwürfel" => "Kartoffel",
                      "Kicherebsenmehl" => "Kicherebsen",
                      "Kichererbsen" => "Kicherebsen",
                      "Kichererbsenmehl" => "Kicherebsen",
                      "Kirschsaft" => "Kirschen",
                      "Kirschtomaten" => "Tomate",
                      "Knoblauchpulver" => "Knoblauch",
                      "Knoblauchsalz" => "Knoblauch",
                      "Knoblauchzehe" => "Knoblauch",
                      "Knoblauchzehen" => "Knoblauch",
                      "Knollensellerie" => "Sellerie",
                      "Knuspermüsli" => "Müsli",
                      "Kochbananen" => "Banane",
                      "Kochbanenmehl" => "Banane",
                      "Kokosmehl" => "Kokosnuss",
                      "Kokosflocken" => "Kokosnuss",
                      "Kokosmehl" => "Kokosnuss",
                      "Kokosmilch" => "Kokosnuss",
                      "Kokosnussmilch" => "Kokosnuss",
                      "Kokosraspel" => "Kokosnuss",
                      "Kokosraspeln" => "Kokosnuss",
                      "Kokossirup" => "Kokosnuss",
                      "Korianderkügelchen" => "Koriander",
                      "Korianderpulver" => "Koriander",
                      "Koriandersaat" => "Koriander",
                      "Kreuzkümmel" => "Kümmel",
                      "Kuhmilch" => "Milch",
                      "Kurkumapulver" => "Kurkuma",
                      "Kuvertüre" => "Schokolade",
                      "Käsetortellini" => "Tortellini",
                      "Kürbisfleisch" => "Kürbis",
                      "Kürbiskerne" => "Kürbis",
                      "Kürbiskernöl" => "Kürbis",
                      "Lachs" => "Fisch",
                      "Lachsfilet" => "Fisch",
                      "Lachsschinken"  => "Fisch",
                      "Lammhackfleisch" => "Lamm",
                      "Lammsteak" => "Lamm",
                      "Landjägerwurst" => "Wurst",
                      "Lasagneblätter" => "Lasagne",
                      "Lasagneplatten" => "Lasagne",
                      "Lauchstange" => "Lauch",
                      "Lauchstangen" => "Lauch",
                      "Lauchzwiebel" => "Lauch",
                      "Lauchzwiebelchen" => "Lauch",
                      "Lauchzwiebeln" => "Lauch",
                      "Limetten" => "Limette",
                      "Limettenfruchtsaft" => "Limette",
                      "Limettensaft" => "Limette",
                      "Limettenschale" => "Limette",
                      "Limettenzeste" => "Limette",
                      "Löffelbiskuits" => "Löffelbiskuit",
                      "Magerjoghurt" => "Joghurt",
                      "Magerqaurk" => "Quark",
                      "Magerquark" => "Quark",
                      "Maisgrieß" => "Mais",
                      "Maiskeimöl" => "Mais",
                      "Maismehl" => "Mais",
                      "Maisstärke" => "Mais",
                      "Maistärke" => "Mais",
                      "Mandarinen" => "Mandarine",
                      "Mandelkerne" => "Mandeln",
                      "Mandelmilch" => "Mandeln",
                      "Mandelmus" => "Mandeln",
                      "Mandelsirup" => "Mandeln",
                      "Marshmallows" => "Marshmallow",
                      "Marzipanrohmasse" => "Marzipan",
                      "Matjesfilet" => "Fisch",
                      "Matjesfilets" => "Fisch",
                      "Milchschokolade" => "Schokolade",
                      "Minzsirup" => "Minze",
                      "Mohrrüben" => "Karotte",
                      "Morcheln" => "Pilze",
                      "Morzarella" => "Mozzarella",
                      "Mozarella" => "Mozzarella",
                      "Muskat" => "Muskatnuss",
                      "Muskatblüte" => "Muskatnuss",
                      "Möhre" => "Karotte",
                      "Möhren" => "Karotte",
                      "Mören" => "Karotte",
                      "Naturjoghurt" => "Joghurt",
                      "Nudelplatten" => "Nudeln",
                      "Nussmix" => "Nudeln",
                      "Nelken" => "Nelke",
                      "Olivenöl" => "Oliven",
                      "Orangen" => "Orange",
                      "Orangenkonfitüre" => "Orange",
                      "Orangenmarmelade" => "Orange",
                      "Orangensaft" => "Orange",
                      "Orangenschale" => "Orange",
                      "Orangenschalenabrieb" => "Orange",
                      "Orangensirup" => "Orange",
                      "Oregani" => "Oregano",
                      "Paparika" => "Paprika",
                      "Paprikapulver" => "Paprika",
                      "Paprikaschote" => "Paprika",
                      "Paprikaschoten" => "Paprika",
                      "Parprikaschote" => "Paprika",
                      "Parmesankäse" => "Parmesan",
                      "Pastinaken" => "Pastinake",
                      "Penne" => "Nudeln",
                      "Petersilienblatt" => "Petersilie",
                      "Petersilienwurzel" => "Petersilie",
                      "Petersilienwurzeln" => "Petersilie",
                      "Pfefferkäse" => "Käse",
                      "Pfifferlinge" => "Pfifferlinge",
                      "Pfirsiche" => "Pfirsich",
                      "Pflaumenmus" => "Pflaumen",
                      "Pistazienkerne" => "Pistazien",
                      "Putenbrust" => "Huhn",
                      "Putenbruststreifen" => "Huhn",
                      "Putenschnitzel" => "Huhn",
                      "Reisdrink" => "Reis",
                      "Reisflocken" => "Reis",
                      "Reismehl" => "Reis",
                      "Reismilch" => "Reis",
                      "Reisnudeln" => "Nudeln",
                      "Reispapier" => "Reis",
                      "Reissirup" => "Reis",
                      "Rhabarberkompott" => "Rhabarber",
                      "Ricotta" => "Frischkäse",
                      "Riesenbohnen" => "Bohnen",
                      "Rinderhack" => "Rind",
                      "Rindertartar" => "Rind",
                      "Rindfleisch" => "Rind",
                      "Risotto" => "Reis",
                      "Risottoreis" => "Reis",
                      "Roggenmehl" => "Mehl",
                      "Rohwurst" => "Wurst",
                      "Rosenpaprika" => "Paprika",
                      "Rotbarsch" => "Fisch",
                      "Rotbarschfilet" => "Fisch",
                      "Ruccola" => "Salat",
                      "Ruccolasalat" => "Salat",
                      "Rucola" => "Salat",
                      "Rundkornreis" => "Reis",
                      "Räucherfisch" => "Fisch",
                      "Räucherlachs" => "Fisch",
                      "Sahnejoghurt" => "Joghurt",
                      "Sahnequark" => "Quark",
                      "Salatgurke" => "Gurke",
                      "Salatkopf" => "Salat",
                      "Salbeiblätter" => "Salbei",
                      "Sardellen" => "Fisch",
                      "Scamorza" => "Käse",
                      "Schalotten" => "Schalotte",
                      "Schlagsahne" => "Sahne",
                      "Schlangenbohnen" => "Bohnen",
                      "Schmelzkäse" => "Käse",
                      "Schmorgurke" => "Gurke",
                      "Schneidebohnen" => "Bohnen",
                      "Schnittlauchröllchen" => "Schnittlauch",
                      "Schoko" => "Schokolade",
                      "Schokoaufstrich" => "Schokolade",
                      "Schokoherzen" => "Schokolade",
                      "Schokoladentropfen" => "Schokolade",
                      "Schokoraspel" => "Schokolade",
                      "Schokoraspeln" => "Schokolade",
                      "Schokostreusel" => "Schokolade",
                      "Schokotropfen" => "Schokolade",
                      "Schollenfilet" => "Fisch",
                      "Schweinefilet" => "Schwein",
                      "Schweinefleich" => "Schwein",
                      "Seelachsfilet" => "Fisch",
                      "Seeteufel" => "Fisch",
                      "Seidentofu" => "Tofu",
                      "Sellerieknolle" => "Sellerie",
                      "Selleriewürfel" => "Sellerie",
                      "Sojacreme" => "Soja",
                      "Sojadrink" => "Soja",
                      "Sojafleisch" => "Soja",
                      "Sojaghurt" => "Joghurt",
                      "Sojajoghurt" => "Joghurt",
                      "Sojamilch" => "Milch",
                      "Sojasahne" => "Sahne",
                      "Sojasauce" => "Soja",
                      "Sojaöl" => "Soja",
                      "Soya" => "Soja",
                      "Spagettikürbis" => "Kürbis",
                      "Spaghetti" => "Nudeln",
                      "Speiseqaurk" => "Quark",
                      "Speisequark" => "Quark",
                      "Spiralnudeln" => "Nudeln",
                      "Spirelli" => "Nudeln",
                      "Spitzkohl" => "Kohl",
                      "Stangenbohnen" => "Bohnen",
                      "Staudensellerie" => "Sellerie",
                      "Steckrüben" => "Steckrübe",
                      "Steinpilze" => "Pilze",
                      "Süßkartoffeln" => "Süßkartoffel",
                      "Teigwaren" => "Nudeln",
                      "Thunfisch" => "Fisch",
                      "Tiefkühlspinat" => "Spinat",
                      "Tinkmilch" => "Milch",
                      "Tomaten" => "Tomate",
                      "Tomatenketchup" => "Tomate",
                      "Tomatenmark" => "Tomate",
                      "Tomatenpüree" => "Tomate",
                      "Tomatenstückchen" => "Tomate",
                      "Trinkmilch" => "Milch",
                      "Vanillegeschmack" => "Vanille",
                      "Vanillemark" => "Vanille",
                      "Vanillepuddingpulver" => "Vanille",
                      "Vanillesauce" => "Vanille",
                      "Vanilleschote" => "Vanille",
                      "Vanilleschoten" => "Vanille",
                      "Vanillesirup" => "Vanille",
                      "Vanillezucker" => "Vanille",
                      "Vanillinzucker" => "Vanille",
                      "Vollkorn" => "Mehl",
                      "Vollkornmehl" => "Mehl",
                      "Vollkornnudeln" => "Nudeln",
                      "Vollkornreis" => "Reis",
                      "Vollkornreismehl" => "Mehl",
                      "Vollkornspiralnudeln" => "Nudeln",
                      "Vollmich" => "Milch",
                      "Vollmilch" => "Milch",
                      "Vollmilchjoghurt" => "Joghurt",
                      "Waldhonig" => "Honig",
                      "Walnussöl" => "Walnuss",
                      "Walnußkerne" => "Walnuss",
                      "Walnußöl" => "Walnuss",
                      "Walnüsse" => "Walnuss",
                      "Weizen" => "Mehl",
                      "Weizengrieß" => "Mehl",
                      "Weizenmehl" => "Mehl",
                      "Weizenvollkornmehl" => "Mehl",
                      "Weißkohl" => "Kohl",
                      "Weißmehl" => "Mehl",
                      "Wildpilze" => "Pilze",
                      "Zartbitterschokolade" => "Schokolade",
                      "Ziegengouda" => "Käse",
                      "Zimtstange" => "Zimt",
                      "Zimtzucker" => "Zimt",
                      "Zitronen" => "Zitrone",
                      "Zitronenaft" => "Zitrone",
                      "Zitronensaft" => "Zitrone",
                      "Zitronensaft,etwas" => "Zitrone",
                      "Zitronenschale" => "Zitrone",
                      "Zucchiniblüten" => "Zucchini",
                      "Zwiebeln" => "Zwiebel",
                      "Zwiebelwürfel" => "Zwiebel",
                      "Äpfel" => "Apfel",
                      "Ölivenöl" => "Ölivenöl"
}


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
    ignore_words = %w(Abrieb Amarenakirschen American Anbraten Auflaufform Ausbacken Ausrollen Ausstreichen Backen Becher Bedarf
                      Beete Belieben Besten Bestreichen Bestreuen Bestäuben Beutel Blatt Blätter Braten Brühe Bsp Bund
                      Creme Crème Culinesse Dampfbeutel Deko Dekorieren Doppelrahmstufe Dose Dosen Double Dressing Drink
                      Ecke Einfetten EL El Esslöfel Esslöffel Fertigbacken Fett Fleischliebhaber Form Formen Frisch Frische
                      Fruchtcocktail Fruchtfleisch Förmchen
                      Garnieren Geschmack Gewürze Glas Glasieren Gramm Grand Grauen Grillen Hand Hanneforth Haut Holzspieße
                      Instant Italienische Je Karamelisieren Kerzen Kg Kilo Klein Kleine Kleines Kochen Kochwasser Konserve
                      Kräuter Kräutern Kugel Kugeln Kurzbraten Kühlregal L Liter Lust M Magerstufe Mark Marnier Messerspitze Mexikanisches
                      Mikrowelle Miniknäcke Mischung Msp Muffinform Mühle Nacht Nester
                      Obst-oder Olek Pack Packung Papierförmchen Pck Pck. Pfanne Pk Pkt Portion Pr Priese Prise Provence Pulver
                      Päckchen Quadrate Rahmstufe Rauke Rinde Rohfischfreunde Rote Saft Sahnegeschmack Sambal Saure Sch
                      Schale Schalenabrieb Scheibe Scheiben Schuß Schär Stange Stangen Stck Stein Stiel Stiele Stk Streifen Stärke
                      Stück Stücke Stücken Sumak Süßstoff Tasse Tassen Teil Tetra Tiefkühlregal TK Tk Tl TL Tr Trinkwasser Tropfen Typ
                      Type Tütchen Tüte Vakuumverpackten Verträglichkeit Vortag Wasser Weiße Williams Würfel Würzen
                      Zartbitter Zweig Zweige ¼ ½ übrigens)
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
            san_word = synonyms[word]
            if san_word.present?
              sanitized_array_of_ingredients << san_word
            else
              sanitized_array_of_ingredients << word
            end
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