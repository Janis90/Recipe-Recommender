class ChangeIsIngredientDefaultInIngredient < ActiveRecord::Migration
  def change
    change_column :ingredients, :is_foodcategory, :boolean, default: true
  end
end
