desc 'Reset the spiders to firts page of letter A and enable them.'
task :reset_spiders => :environment do
  Spider.to_a.each do |s|
    s.enabled = true
    s.number = 1
    s.letter = 'A'
    s.save!
  end
end