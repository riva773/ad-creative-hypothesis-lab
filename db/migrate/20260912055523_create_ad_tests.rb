class CreateAdTests < ActiveRecord::Migration[8.1]
  def change
    create_table :ad_tests do |t|
      t.string :network
      t.integer :cpi
      t.decimal :ctr
      t.decimal :cvr
      t.integer :cpm
      t.integer :impression
      t.integer :amount_spent
      t.integer :budget
      t.date :test_start_date
      t.date :test_end_date
      t.timestamps
    end
  end
end
