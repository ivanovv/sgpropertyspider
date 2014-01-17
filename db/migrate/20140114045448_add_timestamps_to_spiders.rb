class AddTimestampsToSpiders < ActiveRecord::Migration
  def change
    change_table :spiders do |t|
      t.timestamps
    end
    change_table :agents do |t|
      t.timestamps
    end
  end
end
