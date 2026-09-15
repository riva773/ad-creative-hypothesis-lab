class RemoveDeletedAtFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :deleted_at, :datetime
  end
end
