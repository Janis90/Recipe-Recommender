class AddUniqueKeyToRecipeAllergies < ActiveRecord::Migration
  def change
    add_index :recipe_allergies, [ :recipe_id, :allergy_id ], unique: true
  end
end
