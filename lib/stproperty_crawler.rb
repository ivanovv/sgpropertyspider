require_dependency 'base_crawler'
class StpropertyCrawler < BaseCrawler

  def generate_url_for(letter, number)
    "#{@agent_list_url}first-name-#{letter.downcase}/page#{number}/size-#{links_per_page_count}/sort-firstname-asc"
  end

  def get_site_id link_href
    link_href.match(/\/property-agent\/(.*)/)[1]
  end

  def get_links page
    page.search('.ca-sr-item .ca-sr-item-info h4 a')
  end

  def links_per_page_count
    50
  end

end