class AgentScraper

  def self.scrap(page)
    new.scrap(page)
  end

  def scrap(page)
    agent_summary = page.at_css('.agent_summary')
    name = agent_summary.at_css('.summarytitle a').text
    company = agent_summary.at_css('.summary1 .greytext').text
    phone = agent_summary.at_css('.orangebold').text
    position = agent_summary.at_css('.summary1 .font14.top5 b').children.first.text
    lic_numbers = agent_summary.css('.summary2 .top15 a')
    license_num = lic_numbers.first.text
    reg_num = lic_numbers.last.text
    agent_desc = page.at_css('#agent_container #agent_description').text
    emails = agent_desc.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i).join(' ')
    site_id = page.css('a').map{|a| a.attributes['href'].try(:value) }.grep(/openLoginDialog/).first.match(/\/agent\/([^']*)/)[1]

    {
        :name => name,
        :company => company,
        :position => position,
        :cea_license_number => license_num,
        :cea_reg_number => reg_num,
        :site_id => site_id
    }
  end

end
