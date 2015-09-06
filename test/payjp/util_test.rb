require File.expand_path('../../test_helper', __FILE__)

module Payjp
  class UtilTest < Test::Unit::TestCase
    should "symbolize_names should convert names to symbols" do
      start = {
        'foo' => 'bar',
        'array' => [{ 'foo' => 'bar' }],
        'nested' => {
          1 => 2,
          :symbol => 9,
          'string' => nil
        }
      }
      finish = {
        :foo => 'bar',
        :array => [{ :foo => 'bar' }],
        :nested => {
          1 => 2,
          :symbol => 9,
          :string => nil
        }
      }

      symbolized = Payjp::Util.symbolize_names(start)
      assert_equal(finish, symbolized)
    end

    should "normalize_opts should reject nil keys" do
      assert_raise { Payjp::Util.normalize_opts(nil) }
      assert_raise { Payjp::Util.normalize_opts(:api_key => nil) }
    end
  end
end
