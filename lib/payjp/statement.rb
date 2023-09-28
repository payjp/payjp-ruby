module Payjp
  class Statement < APIResource
    include Payjp::APIOperations::List

    def create_statement_urls(params = {}, opts = {})
      response, opts = request(:post, create_statement_urls_url, params, opts)
      response
    end

    private

    def create_statement_urls_url
      url + '/statement_urls'
    end
  end
end
