require 'rails_helper'

feature 'RUR/USD exchange rate management GUI', type: :feature do
	context 'default value' do
    it 'is set' do
      old_rate = 33

      visit admin_path
      fill_in 'currency_exchange_rate[forced_value]', with: old_rate
      select '22', from: 'currency_exchange_rate[valid_until(3i)]'
      select 'November', from: 'currency_exchange_rate[valid_until(2i)]'
      select '2020', from: 'currency_exchange_rate[valid_until(1i)]'
      accept_alert do
        click_on 'Set exchange rate!'
      end
      
      wait_for_ajax
      
      visit root_path
      expect(find(:css, '#rate-wrapper .value').text).to eq '33'


      visit admin_path
      select '1', from: 'currency_exchange_rate[valid_until(3i)]'
      select 'November', from: 'currency_exchange_rate[valid_until(2i)]'
      select '2020', from: 'currency_exchange_rate[valid_until(1i)]'
      accept_alert do
        click_on 'Set exchange rate!'
      end

      new_rate = 80
      allow(CurrencyExchange::Sources::CbrRu).to receive(:retrieve).and_return({status: :success, rate: new_rate})

      visit broadcast_currency_update_path
      visit root_path
      expect(find(:css, '#rate-wrapper .value').text).to eq new_rate.to_s
    end
  end
end 