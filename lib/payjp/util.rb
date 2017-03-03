module Payjp
  module Util
    def self.objects_to_ids(h)
      case h
      when APIResource
        h.id
      when Hash
        res = {}
        h.each { |k, v| res[k] = objects_to_ids(v) unless v.nil? }
        res
      when Array
        h.map { |v| objects_to_ids(v) }
      else
        h
      end
    end

    def self.object_classes
      @object_classes ||= {
        # data structures
        'list' => ListObject,

        # business objects
        'account' => Account,
        'card' => Card,
        'charge' => Charge,
        'customer' => Customer,
        'event' => Event,
        'plan' => Plan,
        'subscription' => Subscription,
        'token' => Token,
        'transfer' => Transfer
      }
    end

    def self.convert_to_payjp_object(resp, opts)
      case resp
      when Array
        resp.map { |i| convert_to_payjp_object(i, opts) }
      when Hash
        # Try converting to a known object class.  If none available, fall back to generic PayjpObject
        object_classes.fetch(resp[:object], PayjpObject).construct_from(resp, opts)
      else
        resp
      end
    end

    def self.symbolize_names(object)
      case object
      when Hash
        new_hash = {}
        object.each do |key, value|
          key = (key.to_sym rescue key) || key
          new_hash[key] = symbolize_names(value)
        end
        new_hash
      when Array
        object.map { |value| symbolize_names(value) }
      else
        object
      end
    end

    def self.url_encode(key)
      # URI.escape is obsolete, so just use the code fragment in URI library
      # (from URI::RFC2396_Parser#escape)
      key.to_s.gsub(Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")) do
        us = $&
        tmp = ''
        us.each_byte do |uc|
          tmp << sprintf('%%%02X', uc)
        end
        tmp
      end.force_encoding(Encoding::US_ASCII)
    end

    def self.flatten_params(params, parent_key = nil)
      result = []
      params.each do |key, value|
        calculated_key = parent_key ? "#{parent_key}[#{url_encode(key)}]" : url_encode(key)
        if value.is_a?(Hash)
          result += flatten_params(value, calculated_key)
        elsif value.is_a?(Array)
          result += flatten_params_array(value, calculated_key)
        else
          result << [calculated_key, value]
        end
      end
      result
    end

    def self.flatten_params_array(value, calculated_key)
      result = []
      value.each do |elem|
        if elem.is_a?(Hash)
          result += flatten_params(elem, calculated_key)
        elsif elem.is_a?(Array)
          result += flatten_params_array(elem, calculated_key)
        else
          result << ["#{calculated_key}[]", elem]
        end
      end
      result
    end

    # The secondary opts argument can either be a string or hash
    # Turn this value into an api_key and a set of headers
    def self.normalize_opts(opts)
      case opts
      when String
        { :api_key => opts }
      when Hash
        check_api_key!(opts.fetch(:api_key)) if opts.has_key?(:api_key)
        opts.clone
      else
        raise TypeError.new('normalize_opts expects a string or a hash')
      end
    end

    def self.check_string_argument!(key)
      raise TypeError.new("argument must be a string") unless key.is_a?(String)
      key
    end

    def self.check_api_key!(key)
      raise TypeError.new("api_key must be a string") unless key.is_a?(String)
      key
    end
  end
end
