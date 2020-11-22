var AdminVM = function(formEl) {

  formEl.on('ajax:success', function(response) {
    handleUpdateResult(response.detail[0])
  })

  formEl.on('ajax:error', function(response) {
    alert('Failed to set rate.')
  })

  function handleUpdateResult(result) {
    switch (result.status) {
      case 'success':
          alert('New exchage rate has successfully been set!')
        break;
      case 'error':
        alert('Error occured when updating exchage rate.')
    }
  }
}