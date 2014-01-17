class IpropertyScraper

  def scrap(page)
    td_text = page.to_s
    reg_num = td_text.match(/(?<=CEA Registration Number :\s)([^\s]*)\s?\<br\>/)[1]
    license_num = td_text.match(/(?<=Agency Licence Number :\s)([^\s]*)\s?\<br\>/)[1]
    license_num.gsub!('Handphone', '')
    #"mailto:">17mash11@gmail.com</a>
    #email = td_text[/(?<=Email\s:\s)[^\s*)/]
    email = td_text[/(?<=\"mailto\:\"\>).*?(?=\<\/a)/]
    email = nil if email == 'sgenquiries@iproperty.com'
    onclick_handler = page.at('span a.tooltip').attributes['onclick'].try(:value)
    phone = onclick_handler[/\d{10}/]
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
        :name => name.strip,
        :phone => phone.strip,
        :fax => nil,
        :company => company.strip,
        :position => nil,
        :cea_license_number => license_num.strip,
        :cea_reg_number => reg_num.strip,
        :email => email
    }
  end
end