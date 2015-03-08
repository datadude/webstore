class HomeController < ApplicationController
  def index
    @items = Item.all
    cookies["back_to"] = { :value => request.original_url, :path => '/' }
  end
end
