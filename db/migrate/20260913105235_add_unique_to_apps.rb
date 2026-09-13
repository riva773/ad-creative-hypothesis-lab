class AddUniqueToApps < ActiveRecord::Migration[8.1]
  def change
    add_index :apps, :campaign_name, unique: true
    add_index :ads, [ :app_id, :file_name ], unique: true
  end
end
