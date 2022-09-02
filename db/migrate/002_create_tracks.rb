class CreateTracks < ActiveRecord::Migration[4.2]
  def self.up
    create_table :tracks do |t|
      t.string :name
      t.integer :track_number
      t.integer :song_id
      t.text :score
      t.timestamps
    end
  end

  def self.down
    drop_table :tracks
  end
end
