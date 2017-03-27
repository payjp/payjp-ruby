module Payjp
  module APIOperations
    module Update
      def save(params = {}, opts = {})
        values = self.class.serialize_params(self).merge(params)

        if values.length > 0
          values.delete(:id)

          response, opts = request(:post, url, values, opts)
          refresh_from(response, opts)
        end
        self
      end
    end
  end
end
