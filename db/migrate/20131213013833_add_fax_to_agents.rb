class AddFaxToAgents < ActiveRecord::Migration
  def change
    add_column :agents, :fax, :strinq
  end
end
