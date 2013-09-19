require 'net/http'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Embedded #:nodoc:
      module BitPay
        class Notification < ActiveMerchant::Billing::Embedded::Notification
          include PostsData
          include Common

          # Was the transaction complete?
          def complete?
            status == "Completed"
          end

          def confirmed?
            status == "Confirmed"
          end

          # Status of transaction. List of possible values:
          # <tt>COMPLETE</tt>::
          def status
            params['status']
          end

          # Id of this transaction (uniq BitPay transaction id)
          def transaction_id
            params['id']
          end

          # Id of this transaction (uniq Shopify transaction id)
          def item_id
            params['posData']
          end

          # The net amount credited to the receiver's account.
          def amount
            params['price']
          end

          # The name of the item being charged for.
          def item_name
            params['item_name']
          end

          # The Merchant ID as given by the BitPay system. Used to uniquely identify the receiver's account.
          def merchant_id
            params['merchant_id']
          end
          
          def currency
            params['currency']
          end

          def expiration_time
            params['expirationTime']
          end

          def current_time
            params['currentTime']
          end

          # Generated hash depends on params order so use OrderedHash instead of Hash
          def empty!
            super
            @params  = ActiveSupport::OrderedHash.new
          end
        end
      end
    end
  end
end
