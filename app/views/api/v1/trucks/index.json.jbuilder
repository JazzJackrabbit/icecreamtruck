json.cache! ['api', 'v1', trucks], expires_in: 1.hour do
  json.data do 
    json.trucks do 
      json.array! (trucks) do |truck|
        json.partial! partial: 'api/v1/trucks/truck', locals: {truck: truck}
      end
    end
    json.partial! partial: 'api/v1/partials/pagination', locals: {pagination: @pagination}
  end
end