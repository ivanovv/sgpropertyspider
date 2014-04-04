require 'csv'

desc "Build a CSV with all the agents"
task :generate_csv => :environment do

  Agent.find_each do |agent|
    agent.cea_reg_number = agent.cea_reg_number.strip.upcase if agent.cea_reg_number
  end

  working_dir = File.join(Rails.root, 'public', 'system')

  file_name = File.join(working_dir, 'all_agents.csv')
  CSV.open(file_name, 'wb') do |csv|
    csv << Agent.csv_header

    Agent.select('cea_reg_number, max(id) as id').group(:cea_reg_number).each do |grouping|
      next unless grouping[:cea_reg_number] =~ /[A-Z]\s?\d{5,7}\s?[A-Z]?/
      agent = Agent.find grouping[:id]
      csv << agent.to_csv_row
    end
  end

  system "tar cz -C #{working_dir} -f all.tar.gz all_agents.csv"

  file_name = File.join(working_dir, 'new_agents.csv')
  CSV.open(file_name, 'wb') do |csv|
    csv << Agent.csv_header

    Agent.select('cea_reg_number, max(id) as id').where("created_at > '2014-03-15'").having('max(id) > 39104').group(:cea_reg_number).each do |grouping|
      next unless grouping[:cea_reg_number] =~ /[A-Z]\s?\d{5,7}\s?[A-Z]?/
      agent = Agent.find grouping[:id]
      csv << agent.to_csv_row
    end
  end
  system "tar cz -C #{working_dir} -f new.tar.gz new_agents.csv"
end