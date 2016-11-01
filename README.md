# Recipe-Recommender

## Synopsis

The *Recipe-Recommender* is a prototype for recipe recommendations for groups based on user preferences and restrictions (e.g. allergies and intolerances).

## Code Example

## Motivation

Cooking for bigger groups can cause many problems for hosts, because not everybody likes the same types of food. Furthermore, vegeterians and people that suffer from food allergies might lead to extra meals - that have to be prepared by the host -, just to supply every guest with food. Figuring out all guest's preference and restrictions might be an endeavor, too. In order to figure out suitable recipes based on guest's preferences and food restrictions a recommendation plattform can prevent wasting time and lead to fewer but more suitable meals.

## Installation
This project uses the Ruby on Rails framework with an Postgres database.
I used Ruby version 2.3.1 and Rails 4.2.6.
The needed software can be installed according to: https://gorails.com/setup/ubuntu/16.04.

Setting up this project:
1. Install all dependencies with __bundle install__

2. Move config/database.yml.example -> config/database.yml
	1. Insert a postgres username
	2. Insert names for the databeses e.g. recipe_recommender_development
	3. Run __rake db:create__ to create the database
3. Move config/secrets.yml.example -> config/secrets.yml
	1. Create a __secret_key_base__ with __bundle exec rake secret__
	2. Uncomment __secret_key_base__ and insert the generated key
4. Add the secret key to config/initializers/devise (config.secret_key = Secret_key) 
	The secret key might differ from the one above. But there will be a key shown in the terminal
5. Run the application with __rails server__
	The application can on default be found at port 3000
