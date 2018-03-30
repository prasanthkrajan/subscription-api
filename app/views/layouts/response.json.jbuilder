json.response do
  json.message @message
  json.status @status
end
json.merge! JSON.parse(yield)
