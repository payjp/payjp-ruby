module Payjp
  class Customer < APIResource
    include Payjp::APIOperations::Create
    include Payjp::APIOperations::Delete
    include Payjp::APIOperations::Update
    include Payjp::APIOperations::List
  end
end
