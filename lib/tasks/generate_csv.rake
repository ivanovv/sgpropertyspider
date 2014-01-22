require 'csv'

desc "Build a CSV with all the agents"
task :generate_csv => :environment do

  Agent.find_each do |agent|
    agent.cea_reg_number = agent.cea_reg_number.strip.upcase if agent.cea_reg_number
  end

  file_name = File.join(Rails.root, 'public', 'all_agents.csv')
  CSV.open(file_name, 'wb') do |csv|
    csv << Agent.csv_header

    Agent.group(:cea_reg_number).order(:name) do |agent|
      csv << agent.to_csv_row
    end
  end
end