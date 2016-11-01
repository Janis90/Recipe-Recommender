class Ingredient < ActiveRecord::Base
  has_many :user_ingredients, dependent: :destroy
  has_many :users, through: :user_ingredients

  validates :name, uniqueness: true
  validates :name, presence: true

  after_create :set_new_user_ingredients
  after_update :set_user_ingredients

  def set_user_ingredients
    if self.is_foodcategory_changed?
      if self.is_foodcategory_was
        #legacy_user_ingredients_relationships << UserIngredient.where(ingredient_id: self.id)
        #debugger
        #legacy_user_ingredients_relationships.each do |legacy_user_ingredients_relationships|
        #legacy_user_ingredients_relationship.destroy
        #end
        UserIngredient.where(ingredient_id: self.id).destroy_all
      else
        set_new_user_ingredients
      end
    end
  end

  def set_new_user_ingredients
    User.all.each do |user|
      UserIngredient.create(user_id: user.id, ingredient_id: self.id)
    end
  end
end
