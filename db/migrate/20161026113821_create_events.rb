class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.date :date
      t.time :start_time
      t.time :end_time
      t.belongs_to :creator, index: true
      t.timestamps null: false
    end
  end
end
