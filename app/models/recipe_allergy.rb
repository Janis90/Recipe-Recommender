class RecipeAllergy < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :allergy
end
