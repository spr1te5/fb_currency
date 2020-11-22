var DisplayVM = function(rate, field) {
  function setRate(newRate){
    field.text(newRate)    
  }

  App.currencyRateNotifications = App.cable.subscriptions.create("CurrencyRateNotificationsChannel", {
    received: function(data) {
      setRate(data.rate)
    }
  })

  setRate(rate)
}