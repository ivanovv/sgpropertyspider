class RenameSiteIdToSiteUrl < ActiveRecord::Migration
  def change
    rename_column :agents, :site_id, :site_url
  end
end
