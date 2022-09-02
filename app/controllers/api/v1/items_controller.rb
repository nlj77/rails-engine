class Api::V1::ItemsController < ApplicationController
    def index 
        render json: ItemSerializer.new(Item.all)
    end

    def show 
        render json: ItemSerializer.new(Item.find(params[:id]))
    end

    def create
        item = Item.new(item_params)
        if item.save
            render json: ItemSerializer.new(item), status: 201
        else 
            render status: 404
        end
    end

    def destroy
        render json: ItemSerializer.new(Item.destroy(params[:id]))
    end

    def update
        if Item.update(params[:id], item_params).save
            render json: ItemSerializer.new(Item.update(params[:id], item_params))
        else
            render status: 404
        end
    end

    def find_all
        item_results = Item.item_search_all(params[:name])
        if item_results.present?
            render json: ItemSerializer.new(item_results), status: 200
        else  
            render json: {data: []}, status: 404
        end
    end

    private

    def item_params
        params.permit(:name, :description, :unit_price, :merchant_id)
    end
end