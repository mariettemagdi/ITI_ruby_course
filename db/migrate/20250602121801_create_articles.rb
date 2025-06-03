class CreateArticles < ActiveRecord::Migration[8.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :description
      t.integer :reports_count
      t.boolean :archived
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
