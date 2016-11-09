class AddUniqueKeyToRecipeIngredients < ActiveRecord::Migration
  def change
    add_index :recipe_ingredients, [ :recipe_id, :ingredient_id ], unique: true
  end
end
