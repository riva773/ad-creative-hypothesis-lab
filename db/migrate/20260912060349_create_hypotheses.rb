class CreateHypotheses < ActiveRecord::Migration[8.1]
  def change
    create_table :hypotheses do |t|
      t.text :content, null: false
      t.references :user, null: false
      t.references :app, null: false
      t.timestamps
    end
  end
end
