desc "Merge agents duplicates"
task :merge => :environment do
  Spider.all.each do |spider|
    duplicates = Agent.where(:spider_id => spider.id).group(:cea_reg_number).
        having('count(*) = 2').
        select('max(id) as max_id', 'min(id) as min_id').all
    duplicates.each do |d|
      old_agent = Agent.find d.min_id
      puts "Old agent:"
      puts old_agent.inspect

      new_agent = Agent.find d.max_id
      puts "New agent: "
      puts new_agent.inspect

      puts 'Merge New in to Old?'
      STDOUT.flush
      answer = gets.chomp
      if answer.downcase == 'y'
        new_agent.attributes.each_pair {|k,v| old.agent.attributes[k] = v unless v.nil? || %w(id updated_at created_at).include?(k)}
        old_agent.save!
        new_agent.destroy!
      end
    end
  end
end