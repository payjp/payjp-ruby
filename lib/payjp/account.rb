module Payjp
  class Account < APIResource
    def url
      '/v1/accounts'
    end

    def self.retrieve
      super(Object.new)
    end
  end
end
