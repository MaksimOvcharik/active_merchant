require 'test_helper'
require 'mechanize'
require 'debugger'

class RemoteBitPayTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Embedded
  
  def setup
    @key = fixtures(:bitpay)[:key]
    #@helper = ActiveMerchant::Billing::Embedded::BitPay::Helper.new('500', @gateway[:key], :amount => "120.99", :currency => 'BTC')
  
  end

  def test_returns_error_on_invalid_key
    helper = ActiveMerchant::Billing::Embedded::BitPay::Helper.new('500', "DEADBEEF", :amount => "120.99", :currency => 'BTC')
    result = helper.invoice
    assert_equal result["error"]["type"], "unauthorized"
  end

  def test_successful_invoice
    helper = ActiveMerchant::Billing::Embedded::BitPay::Helper.new('500', @key, :amount => "120.99", :currency => 'BTC')
    invoice = helper.invoice
    assert invoice["id"]
    assert_equal '500', invoice["posData"]
    assert_equal 120.99, invoice["price"]
    assert_equal 'new', invoice["status"]
    assert invoice["url"]
  end

  def test_iframe_url_present
     helper = helper = ActiveMerchant::Billing::Embedded::BitPay::Helper.new('500', @key, :amount => "120.99", :currency => 'BTC')
     invoice = helper.invoice
     iframe_html = helper.viewport
     assert iframe_html
  end

  def test_wallet_redirection
     helper = helper = ActiveMerchant::Billing::Embedded::BitPay::Helper.new('500', @key, :amount => "120.99", :currency => 'BTC')
     mechwarrior = Mechanize.new
     mechwarrior.get(helper.invoice["url"]) do |page|
             mechwarrior.expects(:get).with do |request_uri, params, p|
                     chunks = request_uri.split(/\?|:/)
                     assert_equal "bitcoin", chunks[0]
                     assert_equal "amount=120.99", chunks[2]
             end
             page.link_with(:dom_class => "pay").click()
     end
  end
  
  def return_from(uri)
     ActiveMerchant::Billing::Embedded::BitPay.return(uri.split('?').last)
  end
      
  def notification_from(request)
     ActiveMerchant::Billing::Embedded::BitPay.notification(request.params["QUERY_STRING"])
  end
end
