require_dependency 'base_crawler'

class PropertyguruCrawler < BaseCrawler

  def generate_url_for(letter, number)
    "#{@agent_list_url}/#{letter.upcase}/#{number}"
  end

  def get_site_id link
    link.match(/\/agent\/(.*)/)[1]
  end

  def get_links page
    page.search('.alisting_info .info1 .infotitle a')
  end

end