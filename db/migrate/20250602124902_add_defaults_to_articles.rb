class AddDefaultsToArticles < ActiveRecord::Migration[8.0]
  def change
    change_column_default :articles, :archived ,false
    change_column_default :articles, :reports_count, 0 
  end
end
