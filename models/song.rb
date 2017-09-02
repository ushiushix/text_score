class Song < ActiveRecord::Base
  belongs_to :account
  has_many :tracks, -> { order('track_number') }, :dependent => :destroy
  validates_presence_of :title
  validates_presence_of :tempo
  scope :publics, -> { where(:public => true) }
end
