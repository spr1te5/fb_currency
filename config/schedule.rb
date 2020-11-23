job_type :rbenv_rake, %Q{export PATH=~/.rbenv/shims:~/.rbenv/bin:/usr/bin:$PATH; eval "$(rbenv init -)"; \
                         cd :path && bundle exec rake :task --silent >> ./log/cron.log 2>> ./log/error.log }

every 1.minute do
  rbenv_rake 'fb_currency:synchronize_exchange_rate', path: '/opt/fb/currency_exchange'
end