module CurrencyExchange
  module Operations
    class UpdateLatestFromSource
      cattr_accessor :sources

      self.sources = {
        "#{Codes::RUR}_#{Codes::USD}" => Sources::CbrRu
      }

      def perform(from:, to:)
        source = self.class.sources.fetch("#{from}_#{to}")
        source_rate = source.retrieve
        return source_rate unless source_rate.fetch(:status) == :success

        latest = RetrieveLatest.new.perform(from: from, to: to)
        return latest unless latest.fetch(:status) == :success

        rate = latest.fetch(:rate)
        rate.update!(source_rate: source_rate[:rate])
        {status: :success, rate: rate}
      end
    end
  end
end