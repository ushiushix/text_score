class CreateSongs < ActiveRecord::Migration[4.2]
  def self.up
    create_table :songs do |t|
      t.string :title
      t.integer :tempo
      t.integer :account_id
      t.boolean :public
      t.timestamps
    end
  end

  def self.down
    drop_table :songs
  end
end
