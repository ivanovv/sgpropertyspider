class AddFaxToAgents < ActiveRecord::Migration
  def change
    add_column :agents, :fax, :string
  end
end
