class CreateApps < ActiveRecord::Migration[8.1]
  def change
    create_table :apps do |t|
      t.string :name, null: false
      t.text :explanation
      t.references :user, null: false
      t.timestamps
    end
  end
end
