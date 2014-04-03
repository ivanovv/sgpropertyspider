class AddSiteIdToAgents < ActiveRecord::Migration
  def change
    add_column :agents, :site_id, :integer
    Agent.find_each do |agent|
      agent.site_id = agent.extract_site_id
    end
  end
end
