class Api::V1::MerchantsController < ApplicationController
    def index
        render json: MerchantSerializer.new(Merchant.all)
    end

    def show 
        render json: MerchantSerializer.new(Merchant.find(params[:id]))
    end

    def find
        merchant = Merchant.merchant_search(params[:name])
        if merchant.present?
            render json: MerchantSerializer.new(merchant), status: 200
        else  
            render json: {data: Merchant.new}, status: 404
        end
    end
end
