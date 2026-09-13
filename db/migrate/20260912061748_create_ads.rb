class CreateAds < ActiveRecord::Migration[8.1]
  def change
    create_table :ads do |t|
      t.references :app, null: false
      t.references :hypothesis, null: false
      t.references :user, null: false
      t.string :file_name, null: false
      t.timestamps
    end
  end
end
