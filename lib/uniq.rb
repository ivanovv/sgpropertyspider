require 'csv'

MONTHS = %w(january february march april may june july august september october november december)
month = ARGV[0].downcase
puts "Need a month" && exit unless MONTHS.include? month
previous_month_index = MONTHS.find_index(month) - 1
previous_month_index = 11 if previous_month_index < 0
previous_month = MONTHS[previous_month_index]


uniq_rows =[]
all_agents = IO.read File.join(previous_month, 'all_agents.csv')

CSV.foreach(File.join(month, 'new_agents.csv'), :headers => true) do |row|
  unless all_agents.include? row['CEA Registration Number']
    uniq_rows << row
  end
end

CSV.open(File.join(month, 'uniq_new_agents.csv')) do |csv|
  uniq_rows.each {|r| csv << r}
end
