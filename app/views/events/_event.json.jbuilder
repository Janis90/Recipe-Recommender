json.extract! event, :id, :title, :description, :date, :start_time, :end_time, :created_at, :updated_at
json.url event_url(event, format: :json)