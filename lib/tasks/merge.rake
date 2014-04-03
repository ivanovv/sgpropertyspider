desc "Merge agents duplicates"
task :merge => :environment do
  def ask message
    print message
    STDIN.gets.chomp
  end

  Spider.all.each do |spider|
    duplicates = Agent.where(:spider_id => spider.id).group(:cea_reg_number).
        having('count(*) = 2').
        select('max(id) as max_id', 'min(id) as min_id').all
    duplicates.each do |d|
      old_agent = Agent.find d.min_id
      new_agent = Agent.find d.max_id
      new_agent.attributes.each_pair do |k,v|
        unless %w(updated_at created_at).include?(k)
          puts "#{k}:\t#{old.agent.attributes[k]}\t#{v}" if old.agent.attributes[k] != v
        end
      end
      answer = ask 'Merge New into Old?'
      if answer.downcase == 'y'
        new_agent.attributes.each_pair {|k,v| old.agent.attributes[k] = v unless v.nil? || %w(id updated_at created_at).include?(k)}
        old_agent.save!
        new_agent.destroy!
      end
    end
  end
end