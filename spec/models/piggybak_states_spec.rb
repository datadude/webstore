require 'rails_helper'

describe 'Piggybak::State', :type => :model do
  fixtures :piggybak_states
  it "should find a state" do
    puts Piggybak::State.find(6918)
    expect(Piggybak::State.first.abbr).to eq 'MT'
  end
end