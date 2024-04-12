require "sinatra"
require "sinatra/reloader"
require "http"
require "json"
require "better_errors"
require "binding_of_caller"
use(BetterErrors::Middleware)
BetterErrors.application_root = __dir__
BetterErrors::Middleware.allow_ip!('0.0.0.0/0.0.0.0')

get("/") do
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATE_KEY"]}"
  
  raw_api_data = HTTP.get(api_url)
  
  raw_api_data_string = raw_api_data.to_s

  parsed_api_data = JSON.parse(raw_api_data_string)
  
  results_array = parsed_api_data.fetch("currencies")

  @symbols = []
  @currencies = []
  results_array.each do |key, value|
    a_symbol = key
    a_currency = value
    @symbols.push(a_symbol)
    @currencies.push(a_currency)
  end
  
  erb(:homepage)
end

get("/:from_currency") do
  @original_currency = params.fetch("from_currency")

  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATE_KEY"]}"
  
  pp @original_currency
  
  erb(:from_currency)
  # some more code to parse the URL and render a view template
end

get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")

  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV["EXCHANGE_RATE_KEY"]}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"
  
  # some more code to parse the URL and render a view template
end
