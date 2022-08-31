require 'rails_helper'

RSpec.describe "Merchants API" do
    it "sends a list of merchants" do
        create_list(:merchant, 3)

        get '/api/v1/merchants'

        expect(response).to be_successful
        merchants = JSON.parse(response.body, symbolize_names: true)
        expect(merchants[:data].count).to eq(3)

        merchants[:data].each do |merchant|
            expect(merchant).to have_key(:id)
            expect(merchant[:id]).to be_an(String)
    
            expect(merchant[:attributes]).to have_key(:name)
            expect(merchant[:attributes][:name]).to be_a(String)
    
            expect(merchant[:attributes]).to_not have_key(:created_at)

    
            expect(merchant[:attributes]).to_not have_key(:updated_at)
        end 
    end

    it " can return a particular merchant" do
        id = create(:merchant).id

        get "/api/v1/merchants/#{id}"

        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful

        expect(merchant[:data]).to have_key(:id)
        expect(merchant[:data][:id]).to eq("#{id}")
    end

    it "can return a particular merchant's items" do 
        merchant = create(:merchant)
        snack_food = ['Hot Dog', 'Ice Cream Cone', 'Popcorn', 'Churro', 'Nachos']
        5.times do
            Item.create(name: "Carnival #{snack_food.sample}", description: 'A tasty treat', unit_price: rand(2..10).to_f, merchant_id: merchant.id)
        end

        get "/api/v1/merchants/#{merchant.id}/items"
        merchant_items = JSON.parse(response.body, symbolize_names: true)
        
        expect(response).to be_successful

        expect(merchant_items[:data].count).to eq(5)
        expect(merchant_items[:data].first).to have_key(:id)
        expect(merchant_items[:data].first).to have_key(:type)
        expect(merchant_items[:data].first).to have_key(:attributes)
        expect(merchant_items[:data].first[:attributes][:description]).to eq('A tasty treat')
    end
end