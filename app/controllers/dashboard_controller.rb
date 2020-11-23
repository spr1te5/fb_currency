class DashboardController < ApplicationController
  def display
    @rate = CurrencyExchange::Operations::RetrieveLatest.perform(from: CurrencyExchange::Codes::RUR, 
                                                                 to: CurrencyExchange::Codes::USD)
    @value = @rate.rate
  end

  def admin
    @rate = CurrencyExchange::Operations::RetrieveLatest.perform(from: CurrencyExchange::Codes::RUR, 
                                                                 to: CurrencyExchange::Codes::USD)
    @value = @rate.rate
  end

  def update_rate
    new_rate = params.require(:currency_exchange_rate).permit(:forced_value, :valid_until)

    update_result = CurrencyExchange::Operations::SetNewRate.perform(from: CurrencyExchange::Codes::RUR, 
                                                                     to: CurrencyExchange::Codes::USD,
                                                                     rate: new_rate)

    case update_result[:status]
    when :success
      @response_status = :ok
    when :error
      @response_status = :unprocessable_entity
    end

    respond_to do |format|
      format.json do 
        render json: update_result, status: @response_status
      end
    end
  end

  def broadcast_currency_update
    result = CurrencyExchange::Operations::UpdateAndNotifyClients.perform(from: CurrencyExchange::Codes::RUR, 
                                                                          to: CurrencyExchange::Codes::USD)
    render json: result
  end
end