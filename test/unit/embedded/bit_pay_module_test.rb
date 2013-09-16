require 'test_helper'

class BitPayModuleTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Embedded

  def test_helper_method
    assert_instance_of BitPay::Helper, BitPay.helper(123, 'test')
  end

  def test_notification_method
    assert_instance_of BitPay::Notification, BitPay.notification('name=cody')
  end

  def test_test_process_mode
    ActiveMerchant::Billing::Base.integration_mode = :test
    assert_equal "https://bitpay.com/api", BitPay.service_url
  end

  def test_test_validate_mode
    ActiveMerchant::Billing::Base.integration_mode = :test
    assert_equal "https://bitpay.com/api", BitPay.validate_service_url
  end

  def test_production_process_mode
    ActiveMerchant::Billing::Base.integration_mode = :production
    assert_equal "https://bitpay.com/api", BitPay.service_url
  end

  def test_production_validate_mode
    ActiveMerchant::Billing::Base.integration_mode = :production
    assert_equal "https://bitpay.com/api", BitPay.validate_service_url
  end

  def test_invalid_mode
    ActiveMerchant::Billing::Base.integration_mode = :winterfell
    assert_raise(StandardError) { BitPay.service_url }
    assert_raise(StandardError) { BitPay.validate_service_url }
  end
end
