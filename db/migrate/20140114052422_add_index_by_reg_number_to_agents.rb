class AddIndexByRegNumberToAgents < ActiveRecord::Migration
  def change
    add_index(:agents, :cea_reg_number)
  end
end
