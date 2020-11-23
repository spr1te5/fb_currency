class CurrencyExchangeRate < ApplicationRecord
  validates :from_code, presence: true, numericality: true
  validates :to_code, presence: true, numericality: true
  validates :forced_rate, numericality: true, if: -> { !forced_rate.nil? }
  validates :source_rate, numericality: true, if: -> { !source_rate.nil? }

  default_value_for :source_rate, 0
  default_value_for :forced_rate, 0

  default_value_for :source_rate_degree, allows_nil: false, value: 0
  default_value_for :forced_rate_degree, allows_nil: false, value: 0

  default_value_for :updated, false

  before_save :set_updated

  def rate
    if valid_until
      Time.now.to_date <= valid_until ? forced_value : source_value
    else
      source_value
    end
  end

  def forced_value
    get_value :forced_rate
  end

  def forced_value= (new_value)
    set_value :forced_rate, new_value
  end

  def source_value
    get_value :source_rate
  end

  def source_value= (new_value)
    set_value :source_rate, new_value
  end

  def updated_for_notifications?
    updated
  end

  def not_updated_for_notifications!(persist)
    self.updated = false
    save! if persist
  end

  private

  def set_updated
    self.updated ||= chanded_for_notification?
  end

  def chanded_for_notification?
    source_rate_changed? ||
    forced_rate_changed? ||
    valid_until_changed?
  end

  def set_value(name, new_value)
    string_value = new_value.to_s
    string_value.strip!
    string_value =~ /\.(\d+)$/
    degree = $1 ? $1.length : 1
    send("#{name}=", (BigDecimal(string_value) * 10**degree).to_i)
    send("#{name}_degree=", degree)
  end

  def get_value name
    send(name).to_f / 10**send("#{name}_degree")
  end
end
