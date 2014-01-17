require_dependency 'propertyguru_scraper'
require_dependency 'stproperty_scraper'
require_dependency 'iproperty_scraper'
require 'url_to_symbol'

class ScraperFactory
  extend UrlToSymbol

  def self.create_scraper_for url
    Rails.logger.debug "URL = #{url}"
    settings = YAML::load(File.open(Rails.root.join("config", "spider.yml")))

    settings['urls'].each do |k, v|
      if url =~ Regexp.new(v)
        return create_scraper(k)
      end
    end

    raise "Unknown scraper for website '#{url}'."
  end

  def self.create_scraper(site)
    "#{pseudoname_to_realname(site)}Scraper".constantize.new
  end

end