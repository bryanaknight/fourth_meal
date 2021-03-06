require 'spec_helper'

describe OrdersController do

  it "routes to :slug/orders/:id/purchase" do
    restaurant = FactoryGirl.create(:restaurant)
    expect(:post => "#{restaurant.slug}/orders/99/purchase").to route_to(
          :controller => "orders",
          :action => "purchase",
          :slug => "bryana-s",
          :id => "99"
   )
  end

  describe "logging out" do
    it "routes to /log_out" do
      expect(:post => "/log_out").to route_to(
             :controller => "sessions",
             :action => "destroy"
      )
    end
  end

  describe "creating a new restaurant" do 
    it "defaults to pending when created" do 
      restaurant = Restaurant.create(title: "Rolen's", description: "Asian Goodness")
      expect(restaurant.status).to eq "pending"
    end
  end

  describe "POST guest_confirm_purchase" do 

    before :each do 
      GuestOrderMailerWorker.stub :perform_async
      @order = Order.create(restaurant_id: 1, status: "unsubmitted")
      user_id = User.new_guest_user_id
      session[:user_id] = user_id
      session[:order_id] = @order.id
    end

    it "purchases an order" do 
      post(:guest_confirm_purchase, user: {email: "abc@example.com",
                            full_name: "Jonah",
                            credit_card_number: "1234123412341234",
                            billing_street: "123 Main st",
                            billing_city: "Denver",
                            billing_apt: "104",
                            billing_state: "CO",
                            billing_zip_code: "80206"})  
      expect(@order.reload.status).to eq "paid"
    end
  end

end
