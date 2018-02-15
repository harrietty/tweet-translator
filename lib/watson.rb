require "net/http"
require "uri"
require "json"
require_relative "../config"

def translate(text)
  uri = URI.parse("https://gateway.watsonplatform.net/language-translator/api/v2/translate")
  request = Net::HTTP::Post.new(uri)
  request.basic_auth($configuration[:watson][:username], $configuration[:watson][:password])
  request.content_type = "application/json"
  request["Accept"] = "application/json"
  request.body = JSON.dump({
    "text" => text,
    "model_id" => "en-es-conversational"
  })

  req_options = {
    use_ssl: uri.scheme == "https",
  }

  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end

  response
end