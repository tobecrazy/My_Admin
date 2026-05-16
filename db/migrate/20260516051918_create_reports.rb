class CreateReports < ActiveRecord::Migration[8.1]
  def change
    create_table :reports do |t|
      t.integer :row_index
      t.string :item_name
      t.date :start_date
      t.string :status
      t.string :comments

      t.timestamps
    end
  end
end
