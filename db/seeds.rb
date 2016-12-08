# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Fill Database with  Recipes and Ingredients
crawler = WebCrawler.new('http://www.lecker-ohne.de/alle-rezepte?ka=1&titel=&field_rezeptzutaten_value=&items_per_page=40', Recipe::MENU_TYPE[0])
crawler.crawl

crawler = WebCrawler.new('http://www.lecker-ohne.de/alle-rezepte?ka=6&titel=&field_rezeptzutaten_value=&items_per_page=40', Recipe::MENU_TYPE[1])
crawler.crawl

crawler = WebCrawler.new('http://www.lecker-ohne.de/alle-rezepte?ka=7&titel=&field_rezeptzutaten_value=&items_per_page=40', Recipe::MENU_TYPE[2])
crawler.crawl

#Set food_categories

# Create new admin user
u = User.new(:email => "admin@abc.de", :password => 'password')
u.username = 'admin'
u.first_name = 'admin'
u.last_name = 'admin'
u.admin = true
u.save

#Create dependencies in graph database
@neo = Neography::Rest.new({ :username => "user", :password => "user"})
zutat = @neo.create_node( "name" => "Zutat")
intoleranz = @neo.create_node( "name" => "Intoleranz")
laktoseintoleranz = @neo.create_node( "name" => "Laktoseintoleranz")
@neo.create_relationship("is_intoleranz", intoleranz, laktoseintoleranz)

laktose_zutaten = %w(Butter Buttermilch Buttermilchpulver Camembert Dickmilch Doppelrahmfrischkäse
                     E966 Edamer Eiscreme Feta Fruchtbuttermilch Fruchteiscreme Gouda Grießbrei
                     Hüttenkäse Joghurt Joghurteis Jogurt
                     Kaffeesahne Kamelmilch Kefir Kefirpulver Kefit Kondensmilch Kuhmilch Lactitol Lactose Laktit Laktose
                     Magermilch Magermilchpulver Magerquark Magertopfen Margarine Mascarpone Milch Milcherzeugnis
                     Milchpulver Milchschokolade Milchzubereitung Milchzucker Molke Molkenerzeugnisse Molkenpulver Mozzarella
                     Parmesan Pferdemilch Pudding Quark Rahm Ricotta Roquefort
                     Sahne Sahneeis Sahnefruchtjoghurt Sauermolke Sauermolkepulver Sauerrahm Saure-Sahne Schafsmilch
                     Schlagsahne Schmelzkäse Schokoladenzubereitung Sorbit Speiseeis Speisequark Stutenmilch Süßmolke Süßmolkenpulver
                     Tilsiter Topfen Trockenmagermilch Trockenvollmilch Vollmilch Vollmilchpulver Ziegenmilch)

laktose_zutaten.each do |zutat|
  new_zutat = @neo.create_node( "name" => zutat)
  @neo.create_relationship("is_zutat", zutat, new_zutat)
  @neo.create_relationship("verursacht", intoleranz, new_zutat)
end

