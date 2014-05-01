class IpropertyScraper

  def scrap(page)
    td_text = page.to_s
    reg_num = td_text.match(/(?<=CEA Registration Number :\s)([^\s]*)\s?\<br\>/)[1] rescue nil
    return nil unless reg_num
    license_num = td_text.match(/(?<=Agency Licence Number :\s)([^\s]*)\s?\<br\>/)[1] rescue nil
    license_num.gsub!('Handphone', '') if license_num
    email_match = td_text.match(/\"mailto\:\"[^\>]*?\>(.*?)(?=\<\/a)/)
    email = email_match[1].strip if email_match
    email = nil if email == 'sgenquiries@iproperty.com'

    phone = nil
    begin
      onclick_handler = page.at('span a.tooltip').attributes['onclick'].try(:value)
      phone = onclick_handler[/\d{10}/]
    rescue
    end

    company = page.css('a').select do |a|
      href = a.attributes['href'].try(:value)
      href =~ /realestateagency/
    end.first.attributes['title'].try(:value)
    name_link = page.css('a').select do |a|
      href = a.attributes['href'].try(:value)
      href =~ /realestateagent/
    end.first
    name = name_link.attributes['title'].try(:value)

    {
        :name => name,
        :phone => phone,
        :fax => nil,
        :company => company,
        :position => nil,
        :cea_license_number => license_num,
        :cea_reg_number => reg_num,
        :email => email
    }
  end
end