class AddColumnCampaignNameToApp < ActiveRecord::Migration[8.1]
  def change
    add_column :apps, :campaign_name, :string, null: false
  end
end
