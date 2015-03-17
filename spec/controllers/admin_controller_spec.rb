require 'rails_helper'

RSpec.describe RailsAdmin::MainController, :type => :controller do
  fixtures :users
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in User.find(2)
  end

end
