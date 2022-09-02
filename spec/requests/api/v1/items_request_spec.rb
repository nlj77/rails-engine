require 'rails_helper'

RSpec.describe "Items API" do
    it "sends a list of merchants" do
        merchant_1 = create(:merchant)
        # create_list(:item, 3) couldn't figure out how to make a neat combined create list
        item_1 = create(:item, merchant_id: merchant_1.id)
        item_2 = create(:item, merchant_id: merchant_1.id)
        item_3 = create(:item, merchant_id: merchant_1.id)

        get '/api/v1/items'

        expect(response).to be_successful
        items = JSON.parse(response.body, symbolize_names: true)
        expect(items[:data].count).to eq(3)

        items[:data].each do |item|
            expect(item).to have_key(:id)
            expect(item[:id]).to be_an(String)
    
            expect(item[:attributes]).to have_key(:name)
            expect(item[:attributes][:name]).to be_a(String)
            expect(item[:attributes][:unit_price]).to be_a(Float)
            expect(item[:attributes][:description]).to be_a(String)

            expect(item[:attributes]).to_not have_key(:created_at)
            expect(item[:attributes]).to_not have_key(:updated_at)
        end 
    end

    it " can return a particular item" do
        merchant_id = create(:merchant).id
        id = create(:item, merchant_id: merchant_id).id

        get "/api/v1/items/#{id}"

        item = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful

        expect(item[:data]).to have_key(:id)
        expect(item[:data][:id]).to eq("#{id}")
    end

    it 'can create and destroy a new item' do
        merchant_id = create(:merchant).id
        item_params = { name: 'Steak Burrito', description: 'You will regret this', unit_price: 10.50, merchant_id: merchant_id }
        headers = { "CONTENT_TYPE" => "application/json" }
    
        post '/api/v1/items', params: JSON.generate(item_params), headers: headers
        expect(response).to be_successful
        expect(response.content_type).to eq("application/json")
    
        item = Item.first
    
        expect(item.name).to eq(item_params[:name])

        delete "/api/v1/items/#{item.id}"
        expect(response).to be_successful
        expect(response.content_type).to eq("application/json")
    end

    it 'can update an item' do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant_id: merchant_1.id)
        initial_price = item_1.unit_price
        new_price = { unit_price: 55.60 }
        headers = { "CONTENT_TYPE" => "application/json" }
    
        patch "/api/v1/items/#{item_1.id}", params: JSON.generate(new_price), headers: headers
    
        expect(response).to be_successful
        expect(response.content_type).to eq("application/json")
    
        updated_item = Item.find(item_1.id)
        expect(updated_item.unit_price).to_not eq(initial_price)
        expect(updated_item.unit_price).to eq(new_price[:unit_price])

        item_params = { name: "Chocolate Bunny", merchant_id: 999 }

        # new_price_2 = { unit_price: 55.60 }

        patch "/api/v1/items/#{item_1.id}", params: JSON.generate(item_params), headers: headers

        expect(response).to_not be_successful
    end

    it "can find an item's merchant " do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant_id: merchant_1.id)

        get "/api/v1/items/#{item_1.id}/merchant"

        expect(response).to be_successful
    end

    it "can find all items that match a search term" do
        merchant_1 = create(:merchant)
        # item_1 = Item.new(name: "Burger", description: "A beef patty served on a bun", unit_price: 10.50, merchant_id: merchant_1.id)
        # item_2 = Item.new(name: "Cheeseburger", description: "A beef patty served on a bun with cheese", unit_price: 11.50, merchant_id: merchant_1.id)
        # item_3 = Item.new(name: "Beef and Broccoli", description: "A stir fry of beef and broccoli", unit_price: 12.50, merchant_id: merchant_1.id)
        # item_4 = Item.new(name: "Chicken Wings", description: "Fried chicken wings with sauce", unit_price: 9.50, merchant_id: merchant_1.id)
        item_1 = merchant_1.items.create(name: "Burger", description: "A beef patty served on a bun", unit_price: 10.50)
        item_2 = merchant_1.items.create(name: "Cheeseburger", description: "A beef patty served on a bun with cheese", unit_price: 11.50)
        item_3 = merchant_1.items.create(name: "Beef and Broccoli", description: "A stir fry of beef and broccoli", unit_price: 12.50)
        item_4 = merchant_1.items.create(name: "Chicken Wings", description: "Fried chicken wings with sauce", unit_price: 9.50)

        # attribute = "description"
        # query_parameter = "beef"

        get "/api/v1/items/find_all?name=burger"
        expect(response).to be_successful
        expect(response.content_type).to eq("application/json")

        results = JSON.parse(response.body, symbolize_names: true)
        expect(results[:data].count).to eq(2)

    end
end