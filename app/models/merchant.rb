class Merchant < ApplicationRecord
    has_many :items
    validates_presence_of :name
    def self.merchant_search(name)
        where("name ILIKE ?", "%#{name}%").order(name: :asc).first
    end
end
