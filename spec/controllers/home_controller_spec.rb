require 'rails_helper'

RSpec.describe HomeController, :type => :controller do
  before do
    controller.request.env['HTTP_HOST'] = 'testhost.mydomain.com'
    controller.request.env['REQUEST_URI'] = '/'
    #allow_any_instance_of(ActionController::TestRequest).to receive(:original_url){'http://testhost.mydomain.com/'}
  end

  describe "GET index" do
    before do
      get :index
    end
    it "assigns @items" do
      items = Item.all
      expect(assigns(:items)).to eq(items)
    end
    it "renders the index template" do
      expect(response).to render_template("index")
    end
    it "sets a cookie" do
      expect(response.cookies["back_to"]).to eq('http://testhost.mydomain.com/')
    end
  end
end
