class AddUrlToSpider < ActiveRecord::Migration
  def change
    add_column :spiders, :agent_list_url, :string
    add_column :spiders, :site_id_url, :string
  end
end
