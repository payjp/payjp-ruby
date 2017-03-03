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

    should "url_encode should escape only UNRESERVED characters" do
      unreserved = %q|!'()*-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~|
      (0..255).each do |c|
        s = [c].pack("C")
        if unreserved.include?(s)
          assert_equal(s, Payjp::Util.url_encode(s))
        else
          assert_equal("%"+sprintf("%02X", c), Payjp::Util.url_encode(s))
        end
      end
    end
  end
end
