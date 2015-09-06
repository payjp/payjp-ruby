module Payjp
  class Card < APIResource
    include Payjp::APIOperations::Create
    include Payjp::APIOperations::Update
    include Payjp::APIOperations::Delete
    include Payjp::APIOperations::List

    def url
      if respond_to?(:customer)
        "#{Customer.url}/#{CGI.escape(customer)}/cards/#{CGI.escape(id)}"
      end
    end

    def self.retrieve(_id, _opts = nil)
      raise NotImplementedError.new("Cards cannot be retrieved without a customer ID. Retrieve a card using customer.cards.retrieve('card_id')")
    end
  end
end
