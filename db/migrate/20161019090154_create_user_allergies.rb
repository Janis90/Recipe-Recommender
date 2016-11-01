class CreateUserAllergies < ActiveRecord::Migration
  def change
    create_table :user_allergies do |t|
      t.references :user,    index: true, foreign_key: true
      t.references :allergy, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
