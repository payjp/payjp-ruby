module Payjp
  class Statement < APIResource
    include Payjp::APIOperations::List

    def statement_urls(params = {}, opts = {})
      response, opts = request(:post, statement_urls_url, params, opts)
      response
    end

    private

    def statement_urls_url
      url + '/statement_urls'
    end
  end
end
