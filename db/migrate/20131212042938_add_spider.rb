class AddSpider < ActiveRecord::Migration
  def up
    create_table :spiders do |t|
      t.integer  :number
      t.string   :letter
      t.boolean :enabled
    end
  end

  def down
    drop_table :spiders
  end
end
