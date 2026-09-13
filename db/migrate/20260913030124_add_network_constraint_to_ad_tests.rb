class AddNetworkConstraintToAdTests < ActiveRecord::Migration[8.1]
  def change
    add_check_constraint :ad_tests,
    "network IS NULL OR network IN ('Meta', 'Google', 'AppLovin')", name: "ad_tests_network_allowed"
  end
end
