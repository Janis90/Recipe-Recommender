class UserIngredient < ActiveRecord::Base
  belongs_to :user
  belongs_to :ingredient

  validates_inclusion_of :rating, in: 1..5

  PRIORITY = {1 => "Hate", 2 => "Dislike", 3 => "It's okay", 4 => "Like", 5 => "Love" }
end
