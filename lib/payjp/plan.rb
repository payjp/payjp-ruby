module Payjp
  class Plan < APIResource
    include Payjp::APIOperations::Create
    include Payjp::APIOperations::Delete
    include Payjp::APIOperations::List
    include Payjp::APIOperations::Update
  end
end
