require 'spec_helper'

describe Restaurant do
  let(:restaurant) { Restaurant.create(:title => "Restaurant 2", :description => "GOOD FOOD") }
  let(:restaurant2) { Restaurant.create(:title => "Restaurant 3", :description => "GOOD FOOD", :status => false) }

  it "creates a restaurant with status being true" do
    restaurant.status.should eq(true)
  end

  describe '.active' do
    it "returns false when status is not active" do
      Restaurant.active.should be_empty
    end

    it "return false when status is active" do
      Restaurant.active.should be_true
    end

  end


  it "should have a slug" do
    restaurant = Restaurant.create(:title => "ABC's Restaurant:", :description => "GOOD FOOD")
    restaurant.slug.should eq("abc-s-restaurant")

    target = Restaurant.find_by(slug: "abc-s-restaurant")
    target.should eq restaurant
  end

end
