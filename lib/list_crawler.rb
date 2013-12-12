require_dependency 'agent_scraper'
class ListCrawler

  HTTP_PREFIX = 'http://'

  UBUNTU_USER_AGENT = 'Mozilla/5.0 (Ubuntu; X11; Linux x86_64; rv:8.0) Gecko/20100101 Firefox/8.0'
  MAC_USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_2) AppleWebKit/534.52.7 (KHTML, like Gecko) Version/5.1.2 Safari/534.52.7'
  MAC_USER_AGENT2 = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.26.17 (KHTML, like Gecko) Version/6.0.2 Safari/536.26.17'
  MAC_USER_AGENT3 = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9) AppleWebKit/537.71 (KHTML, like Gecko) Version/7.0 Safari/537.71'


  attr_accessor :sleep_time, :mechanize, :scraper

  def initialize
    @mechanize = Mechanize.new
    @mechanize.user_agent = [UBUNTU_USER_AGENT, MAC_USER_AGENT, MAC_USER_AGENT2, MAC_USER_AGENT3].sample
    @sleep_time = 7
    #@mechanize.cookie_jar << Mechanize::Cookie.new('conf_arc', '1', :domain => self.class.domain, :path => '/')
    @rnd = Random.new
    @settings = YAML::load(File.open(Rails.root.join("config","spider.yml")))
  end

  def no_agent_in_db(site_id)
    !Agent.find_by_site_id(site_id)
  end

  def absolute_url(relative_link)
    HTTP_PREFIX + self.class.domain + relative_link
  end


  def get_page(letter, number)
    url = @settings['url'] + "#{letter}/#{number}"
    page = @mechanize.get url
    page
  end

  def scrap_agent(link)
    site_id = link.attributes['href'].match(/\/agent\/(.*)/)[1]
    if no_agent_in_db(site_id)
      agent_page = link.click
      agent_attributes = AgentScraper.scrap(agent_page)
      Agent.create(agent_attributes)
      sleep @rnd.rand 3..15
    end
  end


  def parse_page(letter, number)
    page = get_page(letter, number)
    links = page.search('.alisting_info .info1 .infotitle a')
    links.each do |link|
      link = Mechanize::Page::Link.new(link, @mechanize, page)
      scrap_agent link
    end

    if links.count == 10
      [letter, number+1]
    else
      [letter.next, 1]
    end
  end

end