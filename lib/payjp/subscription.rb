module Payjp
  class Subscription < APIResource
    include Payjp::APIOperations::List
    include Payjp::APIOperations::Create
    include Payjp::APIOperations::Update
    include Payjp::APIOperations::Delete

    def pause(params = {}, opts = {})
      response, opts = request(:post, pause_url, params, opts)
      refresh_from(response, opts)
    end

    def resume(params = {}, opts = {})
      response, opts = request(:post, resume_url, params, opts)
      refresh_from(response, opts)
    end

    def cancel(params = {}, opts = {})
      response, opts = request(:post, cancel_url, params, opts)
      refresh_from(response, opts)
    end

    private

    def pause_url
      url + '/pause'
    end

    def resume_url
      url + '/resume'
    end

    def cancel_url
      url + '/cancel'
    end
  end
end
