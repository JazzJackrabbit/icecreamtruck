json.cache! ['api', 'v1', trucks], expires_in: 1.hour do
  json.data do 
    json.trucks do 
      json.array! (trucks) do |truck|
        json.id truck.id
        json.name truck.name
      end
    end
    json.partial! partial: 'api/v1/partials/pagination', locals: {pagination: @pagination}
  end
end