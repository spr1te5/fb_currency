require 'rails_helper'

month_selector = ->(day) {
  find('#currency_exchange_rate_valid_until_2i').all(:css, 'option')[day.month-1].text
}

feature 'RUR/USD exchange rate web-GUI', type: :feature do
  context 'manually set exchange rate last date is today' do
    it 'should display manually set exchange rate' do 
      forced_rate = 33
      today = Time.now.to_date

      visit admin_path
      fill_in 'currency_exchange_rate[forced_value]', with: forced_rate
      select today.day, from: 'currency_exchange_rate[valid_until(3i)]'
      select instance_exec(today, &month_selector), from: 'currency_exchange_rate[valid_until(2i)]'
      select today.year, from: 'currency_exchange_rate[valid_until(1i)]'
      accept_alert do
        click_on 'Set exchange rate!'
      end
      
      wait_for_ajax

      new_rate = 80
      allow(CurrencyExchange::Operations::UpdateLatestFromSource.sources.fetch("#{CurrencyExchange::Codes::RUR}_#{CurrencyExchange::Codes::USD}")).to receive(:retrieve).and_return({status: :success, rate: new_rate})
      CurrencyExchange::Operations::UpdateLatestFromSource.perform(from: CurrencyExchange::Codes::RUR, to: CurrencyExchange::Codes::USD)
      visit root_path
      expect(find(:css, '#rate-wrapper .value').text.to_i).to eq forced_rate
    end
  end

	context 'manually set rate last date is yesterday' do
    it 'should display exchange rate from the source' do
      forced_rate = 33
      yesterday = Time.now.to_date - 1.day
      visit admin_path
      select yesterday.day, from: 'currency_exchange_rate[valid_until(3i)]'
      select instance_exec(yesterday, &month_selector), from: 'currency_exchange_rate[valid_until(2i)]'
      select yesterday.year, from: 'currency_exchange_rate[valid_until(1i)]'
      accept_alert do
        click_on 'Set exchange rate!'
      end
      wait_for_ajax
      
      source_rate = 80
      allow(CurrencyExchange::Operations::UpdateLatestFromSource.sources.fetch("#{CurrencyExchange::Codes::RUR}_#{CurrencyExchange::Codes::USD}")).to receive(:retrieve).and_return({status: :success, rate: source_rate})
      CurrencyExchange::Operations::UpdateLatestFromSource.perform(from: CurrencyExchange::Codes::RUR, to: CurrencyExchange::Codes::USD)
      visit root_path
      expect(find(:css, '#rate-wrapper .value').text.to_i).to eq source_rate
    end
  end
end 