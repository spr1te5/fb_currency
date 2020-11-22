module CurrencyExchange
  module Operations
    class SetNewRate
      def self.perform(from:, to:, rate:)
        result = {}
        latest_rate = RetrieveLatest.perform(from: from, to: to)
        if latest_rate.update(rate)
          result[:status] = :success
        else
          result[:status] = :error
          result[:errors] = latest_rate.errors.details
        end
        result
      end
    end
  end
end
