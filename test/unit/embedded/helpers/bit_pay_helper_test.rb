require 'test_helper'

class BitPayHelperTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Embedded

  def setup
    @helper = BitPay::Helper.new(123, '10000100', :amount => 500, :currency => 'BTC')
  end

  def assign_required_fields
    @helper.itemDesc = 'ZOMG'
    @helper.notify_url = 'http://test.com/pay_fast/paid'
  end

  def test_basic_helper_fields
    assign_required_fields

    assert_field 'price', '500'
    assert_field 'currency', 'BTC'
    assert_field 'account', '10000100'
    assert_field 'itemDesc', 'ZOMG'
    assert_field 'orderID', '123'
    assert_field 'posData', '123'
  end
end
