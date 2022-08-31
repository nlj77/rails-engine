require 'rails_helper'

describe "Merchants API" do
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
end