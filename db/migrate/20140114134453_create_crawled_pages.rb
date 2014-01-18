class CreateCrawledPages < ActiveRecord::Migration
  def change
    create_table :crawled_pages do |t|
      t.column :letter, :string
      t.column :number, :integer
      t.column :started_at, :datetime
      t.column :finished_at, :datetime
      t.column :duration, :integer
      t.references :spider
      t.timestamps
    end
  end
end
