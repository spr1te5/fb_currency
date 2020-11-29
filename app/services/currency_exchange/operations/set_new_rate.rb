module CurrencyExchange
  module Operations
    class SetNewRate
      def self.perform(from:, to:, rate:)
        latest_rate = RetrieveLatest.perform(from: from, to: to)
        return latest_rate unless latest_rate.fetch(:status) == :success

        current_rate = latest_rate.fetch(:rate)
        if current_rate.update(rate)
          {status: :success}
        else
          {
            status: :error,
            errors: latest_rate.errors.details
          }
        end
      end
    end
  end
end
