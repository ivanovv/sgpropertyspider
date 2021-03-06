require_dependency 'scraper_factory'

class BaseCrawler

  HTTP_PREFIX = 'http://'

  UBUNTU_USER_AGENT = 'Mozilla/5.0 (Ubuntu; X11; Linux x86_64; rv:8.0) Gecko/20100101 Firefox/8.0'
  MAC_USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_2) AppleWebKit/534.52.7 (KHTML, like Gecko) Version/5.1.2 Safari/534.52.7'
  MAC_USER_AGENT2 = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.26.17 (KHTML, like Gecko) Version/6.0.2 Safari/536.26.17'
  MAC_USER_AGENT3 = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9) AppleWebKit/537.71 (KHTML, like Gecko) Version/7.0 Safari/537.71'


  attr_accessor :sleep_time, :mechanize, :scraper

  def initialize(agent_list_url, spider_id)
    @mechanize = Mechanize.new
    @mechanize.user_agent = [UBUNTU_USER_AGENT, MAC_USER_AGENT, MAC_USER_AGENT2, MAC_USER_AGENT3].sample
    @sleep_time = 7
    #@mechanize.cookie_jar << Mechanize::Cookie.new('conf_arc', '1', :domain => self.class.domain, :path => '/')
    @rnd = Random.new
    @agent_list_url = agent_list_url
    @spider_id = spider_id
  end

  def no_agent_in_db(site_id)
    !Agent.find_by_site_id(site_id)
  end

  def get_page(letter, number)
    url = generate_url_for letter, number
    Rails.logger.info "url: #{url}"
    @mechanize.get url
  end

  def get_agent_page(link)
    link.click
  end

  def get_agent_link_href(link)
    "#{link.page.uri.scheme}://#{link.page.uri.host}#{link.attributes['href']}"
  end

  def scrap_agent(link)
    link_href = get_agent_link_href(link)
    site_url = get_site_url(link_href)
    site_id = site_url[/\d+/]
    begin
      agent_page = get_agent_page(link)
      agent_attributes = ScraperFactory.create_scraper_for(link_href).scrap(agent_page)
    rescue
      agent_attributes = nil
    end
    return unless agent_attributes
    agent_attributes[:site_url] = site_url
    strip_string_fields(agent_attributes)
    agent = Agent.find_by_site_id(site_id)
    if !agent
      agent_attributes[:spider_id] = @spider_id
      agent_attributes[:site_id] = site_id
      begin
        Agent.create(agent_attributes)
      rescue
        Rails.logger.error agent_attributes
      end
    else
      agent.save_if_changed(agent_attributes)
    end
  end

  def process_link(link, page)
    agent_link = Mechanize::Page::Link.new(link, @mechanize, page)
    Rails.logger.info "agent_link: #{agent_link.inspect}"
    scrap_agent agent_link
    sleep @rnd.rand 3..8
  end

  def parse_page(letter, number)
    page = get_page(letter, number)
    links = get_links(page)
    links.each do |link|
      process_link link, page
    end

    if it_is_a_last_page links
      [letter.next, 1]
    else
      [letter, number+1]
    end
  end

  def links_per_page_count
    50
  end

  def it_is_a_last_page(links)
    Rails.logger.info "#{links.count} #{links_per_page_count}"
    (links.count != links_per_page_count) || links.count == 0
  end

  def strip_string_fields(hash)
    hash.each do |k,v|
      hash[k] = v.strip if (v && v.is_a?(String))
    end

    if hash[:cea_reg_number]
      hash[:cea_reg_number] = hash[:cea_reg_number].strip.upcase
    end

    hash
  end
end
