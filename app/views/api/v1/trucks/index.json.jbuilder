json.data do 
  json.trucks do 
    json.array! (trucks) do |truck|
      json.id truck.id
      json.name truck.name
    end
  end
  json.partial! partial: 'api/v1/partials/pagination', locals: {pagination: @pagination}
end