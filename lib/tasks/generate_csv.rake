require 'csv'

desc "Build a CSV with all the agents"
task :generate_csv => :environment do
  file_name = File.join(Rails.root, 'public', 'agents.csv')
  CSV.open(file_name, 'wb') do |csv|
    csv << Agent.csv_header
    #Agent.order(:id).each do |agent|
    #  csv << agent.to_csv_row
    #end

    Agent.first(500).each do |agent|
      csv << agent.to_csv_row
    end
    Agent.find_each(:start => 3000, :batch_size => 500) do |agent|
      csv << agent.to_csv_row
    end

    Agent.last(500).each do |agent|
      csv << agent.to_csv_row
    end

  end
end