class AddAgents < ActiveRecord::Migration
  def change
  end

  def up
    create_table :agents do |t|
      t.string :site_id
      t.string :phone
      t.string :company
      t.string :position
      t.string :cea_license_number
      t.string :cea_reg_number
      t.string :email
    end
  end

  def down
    drop_table :agents
  end

end
