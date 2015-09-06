module Payjp
  class Token < APIResource
    include Payjp::APIOperations::Create
  end
end
