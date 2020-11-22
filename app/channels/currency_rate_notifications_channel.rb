class CurrencyRateNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'currency_exchange_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
