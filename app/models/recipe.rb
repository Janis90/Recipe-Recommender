class Recipe < ActiveRecord::Base
  has_many :recipe_ingredient, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredient
  has_many :recipe_allergy, dependent: :destroy
  has_many :allergies, through: :recipe_allergy
  has_many :user_recipes, dependent: :destroy
  has_many :users, through: :user_recipes

  belongs_to :recipe_creator, class_name: "User"

  validates :name,          presence: true
  validates :instructions,  presence: true

  MENU_TYPE = ["Vorspeise", "Hauptgericht", "Dessert"].freeze

end
