class Item < ApplicationRecord
    belongs_to :merchant
    validates_presence_of :name
    def self.item_search_all(name)
        where("name ILIKE ?", "%#{name}%")  
    end
end