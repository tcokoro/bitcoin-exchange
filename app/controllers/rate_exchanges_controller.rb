class RateExchangesController < ApplicationController
	def index
		
	end

	def convert
		type = params[:type]
		@currency = params[:currency]
		@amount = params[:amount].to_f
		@order_book = RateExchange.getOrderBook()
		@unit
		@output

		if @currency.to_i == 1
			@unit = 'USD'
			@output = 'BTC'
		else
			@unit = 'BTC'
			@output = 'USD'
		end
		

		if type.to_i == 1
			@quote = RateExchange.getBuyQuote(@order_book, @amount, @unit)
		else
			@quote = RateExchange.getSellQuote(@order_book, @amount, @unit)
		end
	end
end
