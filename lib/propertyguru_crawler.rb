require_dependency 'base_crawler'

class PropertyguruCrawler < BaseCrawler

  def generate_url_for(letter, number)
    "#{@agent_list_url}/#{letter.upcase}/#{number}?items_per_page=#{links_per_page_count}"
  end

  def get_site_url link
    link.match(/\/agent\/(.*)/)[1]
  end

  def get_links page
    page.search('.alisting_info .info1 .infotitle a')
  end

end