desc "Merge agents duplicates"
task :merge => :environment do
  def ask message
    print message
    STDIN.gets.chomp
  end

  Spider.all.reverse.each do |spider|
    STDIN.gets

    duplicates = Agent.where(:spider_id => spider.id).group(:cea_reg_number).
        having('count(*) = 2').
        select('max(id) as max_id', 'min(id) as min_id').all
    duplicates.each do |d|
      puts
      old_agent = Agent.find d.min_id
      new_agent = Agent.find d.max_id
      next if old_agent.site_id != new_agent.site_id
      new_agent.attributes.each_pair do |k,v|
        unless %w(updated_at created_at).include?(k)
          puts "#{k}:\t#{old_agent.attributes[k]}\t#{v}" if old_agent.attributes[k] != v
        end
      end
      new_agent.attributes.each_pair {|k,v| old_agent.attributes[k] = v unless v.nil? || %w(id updated_at created_at).include?(k)}
      old_agent.save!
      new_agent.destroy!
    end
  end
end

#id:	30250	31381
#site_url:	murugan-%28-victor-%29-v/tab-details/user/329128	murugan%28victor%29-v/tab-details/user/285231
#name:	MURUGAN ( VICTOR ) V	murugan(victor) v
#position:	Executive adviser	Executive Adviser
#Merge New into Old?y