require 'rails_helper'

feature 'RUR/USD exchange rate GUI', type: :feature do
	context 'default value' do
    it 'is set' do
      old_rate = 33
      today = Time.now.to_date

      month_selector = ->(day) {
        find('#currency_exchange_rate_valid_until_2i').all(:css, 'option')[day.month-1].text
      }

      visit admin_path
      fill_in 'currency_exchange_rate[forced_value]', with: old_rate
      select today.day, from: 'currency_exchange_rate[valid_until(3i)]'
      select month_selector.(today), from: 'currency_exchange_rate[valid_until(2i)]'
      select today.year, from: 'currency_exchange_rate[valid_until(1i)]'
      accept_alert do
        click_on 'Set exchange rate!'
      end
      
      wait_for_ajax
      
      visit root_path
      expect(find(:css, '#rate-wrapper .value').text).to eq old_rate.to_s

      yesterday = today - 1.day
      visit admin_path
      select yesterday.day, from: 'currency_exchange_rate[valid_until(3i)]'
      select month_selector.(yesterday), from: 'currency_exchange_rate[valid_until(2i)]'
      select yesterday.year, from: 'currency_exchange_rate[valid_until(1i)]'
      accept_alert do
        click_on 'Set exchange rate!'
      end

      new_rate = 80
      allow(CurrencyExchange::Sources::CbrRu).to receive(:retrieve).and_return({status: :success, rate: new_rate})

      CurrencyExchange::Operations::UpdateLatestFromSource.perform(from: CurrencyExchange::Codes::RUR,
                                                                   to: CurrencyExchange::Codes::USD)
      visit root_path
      expect(find(:css, '#rate-wrapper .value').text).to eq new_rate.to_s
    end
  end
end 