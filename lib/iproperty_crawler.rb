require_dependency 'base_crawler'
class IpropertyCrawler < BaseCrawler

  def generate_url_for(letter, number)
    "#{@agent_list_url}findanagent.aspx?ty=al&ak=#{letter}&rk=&p=#{number}&s=#{links_per_page_count}"
  end

  def get_agent_link_href(link)
    uri = URI(@agent_list_url)
    "http://#{uri.host}#{link.at_css('a').attributes['href'].value}"
  end

  def get_site_id(link_href)
    link_href.match(/\/realestateagent\/(.*)/)[1]
  end

  def get_links(page)
    page.search('td.morelistingtext').select do |td|
      td.attributes['rowspan'] && td.attributes['rowspan'].value == '2'
    end
  end

  def links_per_page_count
    100
  end

  def get_agent_page(link)
    link
  end

  def process_link(link, page)
    scrap_agent link
  end
end