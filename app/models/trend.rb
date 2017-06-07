class Trend < ActiveRecord::Base
  validates_each :value do |record, attr, value|
    begin
      JSON.parse(record.value)
    rescue StandardError => e
      record.errors.add(attr, "must be a JSON string")
    end
  end

  after_save { |record| record.value = JSON.parse(record.value) }
  after_find { |record| record.value = JSON.parse(record.value) }
end
