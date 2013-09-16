module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Embedded #:nodoc:
      module BitPay
        class Helper < ActiveMerchant::Billing::Embedded::Helper
          include Common

          def initialize(order, account, options = {})
            super
            add_field('account', account)
            @api_key = account
            add_field('price', options[:amount])
            add_field('currency', options[:currency])
            add_field('orderID', order)
            add_field('posData', order)
          end

          #required
          mapping :account, "account"
          mapping :price, "price"
          mapping :currency, "currency"

          #passthru ID variable
          mapping :posData, "posData"
          mapping :notificationURL, "notificationURL"
          mapping :notificationEmail, "notificationEmail"
          mapping :transactionSpeed, "transactionSpeed"
          mapping :fullNotifications, "fullNotifications"

          mapping :orderID, "orderID"
          mapping :itemDesc, "itemDesc"
          mapping :itemCode, "itemCode"

          mapping :physical, "physical"
          mapping :buyerName, "buyerName"
          mapping :buyerAddress1, "buyerAddress1"
          mapping :buyerAddress2, "buyerAddress2"
          mapping :buyerCity, "buyerCity"
          mapping :buyerState, "buyerState"
          mapping :buyerZip, "buyerZip"
          mapping :buyerCountry, "buyerCountry"
          mapping :buyerEmail, "buyerEmail"
          mapping :buyerPhone, "buyerPhone"

          def invoice
            @invoice ||= begin
              new_invoice_url = "#{BitPay.process_production_url}/invoice?view=iframe"
              response = ssl_post(new_invoice_url, :data => @fields.to_json)
              JSON.parse(response.body)
            end
          end

          def viewport
            ssl_get(invoice["url"])
          end

          private
          def ssl_get(url)
            uri = URI.parse(url)
            site = Net::HTTP.new(uri.host, uri.port)
            site.use_ssl = true
            site.get(uri.request_uri).body
          end

          def ssl_post(url, options = {})
            uri = URI.parse(url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            #http.verify_mode = OpenSSL::SSL::VERIFY_NONE

            request = Net::HTTP::Post.new(uri.request_uri)
            request.content_type = "application/json"
            request.body = @fields.to_json

            headers.each { |k,v| request[k] = v }

            http.request(request)
          end

          def headers
            {
              "Authorization" => "Basic " + Base64.strict_encode64(@api_key.to_s).strip,
              "User-Agent" => "BitPay v1.0/ActiveMerchant #{ActiveMerchant::VERSION}"
            }
          end
        end
      end
    end
  end
end
