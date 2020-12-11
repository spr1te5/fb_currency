module CurrencyExchange
  module Operations
    class RetrieveLatest
      def perform(from:, to:)
        {
          status: :success,
          rate: CurrencyExchangeRate.find_or_create_by!(from_code: from, to_code: to)
        }
      end
    end
  end
end