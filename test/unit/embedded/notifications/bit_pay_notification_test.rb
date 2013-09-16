require 'test_helper'

class BitPayNotificationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Embedded

  def setup
    @bitpay = BitPay::Notification.new(http_raw_data)
  end

  def test_accessors
    assert @bitpay.complete?
    assert_equal "46591", @bitpay.transaction_id
    assert_equal "Completed", @bitpay.status
    assert_equal "Name", @bitpay.item_name
    assert_equal "120.20", @bitpay.amount
    assert_equal "10000100", @bitpay.merchant_id
    assert_equal "BTC", @bitpay.currency
  end

  def test_payment_successful_status
    notification = BitPay::Notification.new('status=COMPLETE')
    assert_equal 'Completed', notification.status
  end

  def test_payment_invalid_status
    notification = BitPay::Notification.new('status=invalid')
    assert_equal 'Failed', notification.status
  end

  def test_payment_expired_status
    notification = BitPay::Notification.new('status=expired')
    assert_equal 'Failed', notification.status
  end

  def test_payment_failure_status
    notification = BitPay::Notification.new('status=FAILED')
    assert_equal 'Failed', notification.status
  end

  private

  def http_raw_data
    "currency=BTC&id=46591&status=COMPLETE&item_name=Name&price=120.20&custom_str1=&custom_str2=&custom_str3=&custom_str4=&custom_str5=&custom_int1=&custom_int2=&custom_int3=&custom_int4=&custom_int5=&name_first=Test&name_last=User+01&email_address=sbtu01%40payfast.co.za&merchant_id=10000100&signature=bae21e96d4dc7bf36bd1a6bb1a103f5f"
  end
end
