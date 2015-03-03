require 'rails_helper'

RSpec.describe RailsAdmin::MainController, :type => :controller do
  fixtures :users
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in User.find(1)
  end

  it 'should sign in to admin page' do
    pending 'currently not finding the route'
    get('index')
  end
end
