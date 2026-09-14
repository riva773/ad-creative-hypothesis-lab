class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.references :user, null: false
      t.references :ad_test, null: false, index: { unique: true }
      t.text :content
      t.timestamps
    end
  end
end
