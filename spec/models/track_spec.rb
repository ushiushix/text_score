require 'spec_helper'

describe "Track Model" do
  let(:track) { Track.new }
  it 'can be created' do
    track.should_not be_nil
  end
end
