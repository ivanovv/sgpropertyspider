class AddMonthToCrawledPages < ActiveRecord::Migration
  def change
    add_column :crawled_pages, :month, :string
    add_column :crawled_pages, :year, :integer
  end
end
