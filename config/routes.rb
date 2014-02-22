BitcoinExchange::Application.routes.draw do
  root 'rate_exchanges#index'
  get '/convert' => "rate_exchanges#convert"
end
