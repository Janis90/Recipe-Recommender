class ChangeIsCategoryIngredientDefault < ActiveRecord::Migration
  def change
    change_column :ingredients, :is_foodcategory, :boolean, default: false
  end
end
