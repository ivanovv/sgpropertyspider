class StpropertyScraper

  def self.scrap(page)
    begin
      new.scrap(page)
    rescue => e
      File.open('error.html','w') {|f| page.write_to f}
      raise e
    end
  end

  def scrap(page)
    agent_summary = page.at('#contactme').attributes['title'].try(:value)
    name = agent_summary[/(?<=Contact\s)[^,]*/]
    name = name[/.*(?= from)/] if name.include?(' from ')
    company = agent_summary[/(?<=\sfrom\s)[^,]*(?=,)/] rescue nil
    phone = agent_summary[/(?<=,\+)[\d\s]*(?=,CEA)/] rescue nil
    position = agent_summary[/(?<=,)[^,]*(?=\sfrom\s)/] rescue nil
    license_num = nil
    reg_num = agent_summary[/(?<=CEA Salesperson RegNo\.\:)R.*/]

    {
        :name => name,
        :phone => phone,
        :fax => nil,
        :company => company,
        :position => position,
        :cea_license_number => license_num,
        :cea_reg_number => reg_num,
        :email => nil
    }
  end
end