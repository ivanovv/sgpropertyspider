require 'csv'

desc "Build a CSV with all the agents"
task :generate_csv => :environment do

  Agent.find_each do |agent|
    agent.cea_reg_number = agent.cea_reg_number.strip.upcase if agent.cea_reg_number
  end

  file_name = File.join(Rails.root, 'public', 'all_agents.csv')
  CSV.open(file_name, 'wb') do |csv|
    csv << Agent.csv_header

    Agent.select('cea_reg_number, max(id) as id').group(:cea_reg_number) do |grouping|
      next unless grouping[:cea_reg_number]
      agent = Agent.find grouping[:id]
      csv << agent.to_csv_row
    end
  end
end