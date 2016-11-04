class CreateRecipeAllergies < ActiveRecord::Migration
  def change
    create_table :recipe_allergies do |t|
      t.references :recipe,    index: true, foreign_key: true
      t.references :allergy,   index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
