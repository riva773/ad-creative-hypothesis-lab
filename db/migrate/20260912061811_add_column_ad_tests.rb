class AddColumnAdTests < ActiveRecord::Migration[8.1]
  def change
    add_reference :ad_tests, :ad, null: false, foreign_key: true
    add_column :ad_tests, :status, :string, null: false
  end
end
