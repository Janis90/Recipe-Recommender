# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Fill Database with  Recipes and Ingredients

#Allergien
allergies = %w( Laktoseintoleranz Fruchtoseintoleranz Histamin-Intoleranz Vegetarisch Vegan
                Kuhmilch-Unverträglichkeit Ei-Unverträglichkeit Soja-Unverträglichkeit Weizen-Unverträglichkeit)

allergies.each do |allergy|
  Allergy.create!(name: allergy)
end

#Create dependencies in graph database
neo = Neography::Rest.new({:username => "user", :password => "user"})
ingredientDependency = IngredientDependency.new(neo)
#ingredientDependency.setup_db

crawler = WebCrawler.new('http://www.lecker-ohne.de/alle-rezepte?ka=1&titel=&field_rezeptzutaten_value=&items_per_page=40', Recipe::MENU_TYPE[0])
crawler.crawl

crawler = WebCrawler.new('http://www.lecker-ohne.de/alle-rezepte?ka=6&titel=&field_rezeptzutaten_value=&items_per_page=40', Recipe::MENU_TYPE[1])
crawler.crawl

crawler = WebCrawler.new('http://www.lecker-ohne.de/alle-rezepte?ka=7&titel=&field_rezeptzutaten_value=&items_per_page=40', Recipe::MENU_TYPE[2])
crawler.crawl

#Set food_categories
food_categories = %w( Ananas Apfel Aprikose Aubergine Avocado Banane Beeren Birne Blumenkohl Bohnen Broccoli Bulgur Buttermilch
                      Champignons Chili Cranberries Curry Datteln Ei Erbsen Erdbeere Erdnuss Erdnussbutter Falafel Feige Fenchel Fisch
                      Fladenbrot Frischkäse Frühlingszwiebel Garnelen Geflügelleber Grapefruit Gurke Hackfleisch Hafer Haselnuss Heidelbeere
                      Himbeeren Hirse Honig Huhn Ingwer Joghurt Johannisbeeren Kaffee Kalb Kapern Kardamon Karotte Kartoffel
                      Kasseler Ketchup Kicherebsen Kirschen Kiwi Knoblauch Kochschinken Kohlrabi Kokosnuss Koriander Krabben Kräuterquark
                      Kurkuma Käse Kümmel Kürbis Lamm Lasagne Lauch Lebkuchenkekse Limette Linsen Mais Mandeln Mango Mangold
                      Maronen Marshmallow Marzipan Masala Mascarpone Meerrettich Mehl Milch Milchreis Minze Moccabohnen Mozzarella Muskatnuss
                      Müsli Nelke Nudeln Oliven Orange Papaya Paprika Paranüsse Parmesan Peperoni Petersilie Pfirsich Pflaumen Pilze
                      Pistazien Porree Quark Radieschen Rahmspinat Reis Rhabarber Rind Rosinen
                      Sahne Salami Salat Salbei Sauerkirschen Sauerkraut Schafskäse Schalotte Schinken Schnittlauch Schokolade
                      Schwein Sellerie Senf Soja Spargel Speck Spinat Steckrübe Süßkartoffel Tabascosauce Tofu Tomate Tortellini
                      Vanille Walnuss Weintrauben Wirsing Wraps Zitrone Zucchini Zwetschgen Zwiebel)

food_categories.each do |food_c|
  ingredient = Ingredient.where(name: food_c).first
  if ingredient.present?
    ingredient.is_foodcategory = true
    ingredient.save!
  end
end

# Create new admin user
u = User.new(:email => "admin@abc.de", :password => 'password')
u.username = 'admin'
u.first_name = 'admin'
u.last_name = 'admin'
u.admin = true
u.save


