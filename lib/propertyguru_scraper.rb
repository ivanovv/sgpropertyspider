class PropertyguruScraper

  def self.scrap(page)
    begin
      new.scrap(page)
    rescue => e
      File.open('error.html','w') {|f| page.write_to f}
      raise e
    end
  end

  def scrap(page)
    agent_summary = page.at('.agent_summary')
    name = page.at('#breadcrumb_title').text
    company = agent_summary.at('.summary1 .greytext').text rescue nil
    phone = agent_summary.at('span.orangebold').text rescue nil
    fax = agent_summary.at('.summary2 span.font14 b').text rescue nil
    position = agent_summary.at('.summary1 .font14.top5 b').children.first.text rescue nil
    lic_numbers = agent_summary.css('.summary2 .top15 a')
    if lic_numbers.count > 0
      license_num = lic_numbers.first.text
      reg_num = lic_numbers.last.text
    end
    agent_desc = page.at('#agent_container #agent_description').text
    emails = agent_desc.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i).join(' ')

    {
        :name => name,
        :phone => phone,
        :fax => fax,
        :company => company,
        :position => position,
        :cea_license_number => license_num,
        :cea_reg_number => reg_num,
        :email => emails.empty? ? nil : emails
    }
  end

end
