class CreateEbooks < ActiveRecord::Migration[8.0]
  def change
    create_table :ebooks do |t|
      t.string :title, null: false
      t.string :author
      t.string :file_type
      t.integer :file_size

      t.timestamps
    end

    add_index :ebooks, :created_at
    add_index :ebooks, :title
    add_index :ebooks, :author
  end
end
