class Recipe < ActiveRecord::Base
  has_many :recipe_ingredient, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredient
  has_many :recipe_allergy, dependent: :destroy
  has_many :allergies, through: :recipe_allergy

  validates :name,          presence: true
  validates :instructions,  presence: true

end
