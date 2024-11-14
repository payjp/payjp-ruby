module Payjp
  class Token < APIResource
    include Payjp::APIOperations::Create

    def self.tds_finish(id, params = {}, opts = {})
      response, opts = request(:post, url + '/' + id + '/tds_finish', params, opts)
      Util.convert_to_payjp_object(response, opts)
    end

    def tds_finish(params = {}, opts = {})
      response, opts = request(:post, tds_finish_url, params, opts)
      refresh_from(response, opts)
    end

    def tds_finish_url
      url + '/tds_finish'
    end
  end
end
