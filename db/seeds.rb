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
neo = Neography::Rest.new({:username => "user", :password => "user"})
ingredientDependency = IngredientDependency.new(neo)
ingredientDependency.setup_db
