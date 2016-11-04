class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :url
      t.text :instructions
      t.string :picture_url
      t.string :menu_type

      t.timestamps null: false
    end
  end
end
