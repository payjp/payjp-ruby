module Payjp
  class Statement < APIResource
    include Payjp::APIOperations::List

    def create_download_urls(params = {}, opts = {})
      response, opts = request(:post, create_download_urls_url, params, opts)
      response
    end

    private

    def create_download_urls_url
      url + '/download_urls'
    end
  end
end
