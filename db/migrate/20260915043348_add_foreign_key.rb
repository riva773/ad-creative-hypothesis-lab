class AddForeignKey < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :apps, :users, column: :user_id
    add_foreign_key :hypotheses, :users, column: :user_id
    add_foreign_key :hypotheses, :apps, column: :app_id
    add_foreign_key :ads, :users, column: :user_id
    add_foreign_key :ads, :apps, column: :app_id
    add_foreign_key :ads, :hypotheses, column: :hypothesis_id
    add_foreign_key :reviews, :users, column: :user_id
    add_foreign_key :reviews, :ad_tests, column: :ad_test_id
  end
end
