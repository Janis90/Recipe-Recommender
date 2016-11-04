class Allergy < ActiveRecord::Base
  has_many :user_allergy, dependent: :destroy
  has_many :users, through: :user_allergy
  has_many :recipe_allergy, dependent: :destroy
  has_many :recipes, through: :recipe_allergy

  validates :name, presence: true
end
