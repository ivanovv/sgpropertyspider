require 'csv'

desc "Build a CSV with all the agents"
task :generate_csv => :environment do
  file_name = File.join(Rails.root, 'public', 'agents.csv')
  CSV.open(file_name, 'wb') do |csv|
    csv << Agent.csv_header
    Agent.order(:id).take(5).each do |agent|
      puts agent.to_s
      csv << agent.to_csv_row
    end
  end
end