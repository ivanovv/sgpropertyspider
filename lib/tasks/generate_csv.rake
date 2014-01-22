require 'csv'

desc "Build a CSV with all the agents"
task :generate_csv => :environment do

  Agent.find_each do |agent|
    agent.cea_reg_number = agent.cea_reg_number.strip.upcase if agent.cea_reg_number
  end

  file_name = File.join(Rails.root, 'public', 'all_agents.csv')
  CSV.open(file_name, 'wb') do |csv|
    csv << Agent.csv_header

    Agent.select('cea_reg_number, max(id) as id').group(:cea_reg_number).each do |grouping|
      next unless grouping[:cea_reg_number] =~ /[A-Z]\s?\d{5,7}\s?[A-Z]?/
      agent = Agent.find grouping[:id]
      csv << agent.to_csv_row
    end
  end
  archive_file_name = File.join(Rails.root, 'public', 'all.tar.gz')
  system "tar tar -cvzf #{archive_file_name} #{file_name}"

  file_name = File.join(Rails.root, 'public', 'new_agents.csv')
  CSV.open(file_name, 'wb') do |csv|
    csv << Agent.csv_header

    Agent.select('cea_reg_number, max(id) as id').where("created_at > '2014-01-01'").having('max(id) > 12464').group(:cea_reg_number).each do |grouping|
      next unless grouping[:cea_reg_number] =~ /[A-Z]\s?\d{5,7}\s?[A-Z]?/
      agent = Agent.find grouping[:id]
      csv << agent.to_csv_row
    end
  end
  archive_file_name = File.join(Rails.root, 'public', 'new.tar.gz')
  system "tar tar -cvzf #{archive_file_name} #{file_name}"
end