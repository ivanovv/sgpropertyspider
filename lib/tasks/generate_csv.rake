require 'csv'

desc "Build a CSV with all the agents"
task :generate_csv => :environment do

  Agent.find_each do |agent|
    agent.cea_reg_number = agent.cea_reg_number.strip.upcase
  end

  file_name = File.join(Rails.root, 'public', 'all_agents.csv')
  CSV.open(file_name, 'wb') do |csv|
    csv << Agent.csv_header

    Agent.order(:id).find_each do |agent|
      csv << agent.to_csv_row
    end
  end
end