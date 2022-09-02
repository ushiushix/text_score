class AddProgramToTrack < ActiveRecord::Migration[4.2]
  def self.up
    change_table :tracks do |t|
      t.integer :program
    end
  end

  def self.down
    change_table :tracks do |t|
      t.remove :program
    end
  end
end
