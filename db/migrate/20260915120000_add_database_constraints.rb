class AddDatabaseConstraints < ActiveRecord::Migration[8.1]
  def up
    remove_index :ads, name: "index_ads_on_hypothesis_id"
    add_index :ads, :hypothesis_id, unique: true
    remove_index :hypotheses, :content, if_exists: true

    change_column_null :reviews, :content, false
    remove_column :users, :role, :string if column_exists?(:users, :role)

    add_check_constraint_unless_exists :ad_tests, "status IN ('結果取り込み済み', 'テスト結果待ち', '振り返り済み')", "ad_tests_status_allowed"
    add_check_constraint_unless_exists :ad_tests, "(cpi IS NULL OR cpi >= 0) AND (cpm IS NULL OR cpm >= 0) AND (impression IS NULL OR impression >= 0) AND (budget IS NULL OR budget >= 0) AND (amount_spent IS NULL OR amount_spent >= 0)", "ad_tests_non_negative_metrics"
    add_check_constraint_unless_exists :ad_tests, "(ctr IS NULL OR ctr BETWEEN 0 AND 100) AND (cvr IS NULL OR cvr BETWEEN 0 AND 100)", "ad_tests_rate_range"
    add_check_constraint_unless_exists :ad_tests, "amount_spent IS NULL OR budget IS NULL OR amount_spent <= budget", "ad_tests_amount_spent_lteq_budget"
    add_check_constraint_unless_exists :ad_tests, "test_start_date IS NULL OR test_end_date IS NULL OR test_end_date >= test_start_date", "ad_tests_test_end_date_gteq_start_date"
    add_check_constraint_unless_exists :users, "char_length(name) <= 20", "users_name_length"
    add_check_constraint_unless_exists :hypotheses, "char_length(content) <= 150", "hypotheses_content_length"
    add_check_constraint_unless_exists :reviews, "char_length(content) <= 1000", "reviews_content_length"

    add_cascade_foreign_key :hypotheses, :apps, :app_id
    add_cascade_foreign_key :ads, :apps, :app_id
    add_cascade_foreign_key :ads, :hypotheses, :hypothesis_id
    add_cascade_foreign_key :ad_tests, :ads, :ad_id
    add_cascade_foreign_key :reviews, :ad_tests, :ad_test_id
  end

  private

  def add_check_constraint_unless_exists(table, expression, name)
    return if connection.check_constraints(table).any? { |constraint| constraint.name == name }

    add_check_constraint table, expression, name: name
  end

  def add_cascade_foreign_key(from_table, to_table, column)
    remove_foreign_key from_table, to_table, column: column
    add_foreign_key from_table, to_table, column: column, on_delete: :cascade
  end
end
