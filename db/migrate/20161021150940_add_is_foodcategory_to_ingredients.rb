class AddIsFoodcategoryToIngredients < ActiveRecord::Migration
  def change
    add_column :ingredients, :is_foodcategory, :boolean, default: false
  end
end
