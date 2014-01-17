require_dependency 'propertyguru_crawler'
require_dependency 'stproperty_crawler'
require_dependency 'iproperty_crawler'
require 'url_to_symbol'

class CrawlerFactory
  extend UrlToSymbol

  def self.create_crawler_for(url, spider_id)

    settings = YAML::load(File.open(Rails.root.join("config", "spider.yml")))

    settings['urls'].each do |k, v|
      if url =~ Regexp.new(v)
        return create_crawler(k, url, spider_id)
      end
    end

    raise "Unknown spider for website '#{url}'."
  end

  def self.create_crawler(site, url, spider_id)
    "#{pseudoname_to_realname(site)}Crawler".constantize.new(url, spider_id)
  end
end