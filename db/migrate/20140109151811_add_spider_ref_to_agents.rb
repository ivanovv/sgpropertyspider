class AddSpiderRefToAgents < ActiveRecord::Migration
  def change
    add_reference :agents, :spider, index: true
  end
end
