class AddRecipeCreatorIdToUser < ActiveRecord::Migration
  def change
    add_reference :recipes, :recipe_creator, index: true
  end
end
