json.message message
json.data do
  json.truck do
    json.partial! partial: 'api/v1/trucks/truck', locals: {truck: truck}
  end
end