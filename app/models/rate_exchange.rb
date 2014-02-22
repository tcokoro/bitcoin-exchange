class RateExchange < ActiveRecord::Base
	include HTTParty

	def self.getOrderBook()
		response = HTTParty.get('https://www.bitstamp.net/api/order_book/')
	end

	def self.getBuyQuote(orderBook, amt, enteredUnit)
		if enteredUnit == "BTC"
			return self.getQuoteUSD(orderBook, 'asks', amt)
		else
			return getQuoteBTC(orderBook, 'asks', amt)
		end
	end

	def self.getSellQuote(orderBook, amt, enteredUnit)
		if enteredUnit == "BTC"
			return getQuoteUSD(orderBook, 'bids', amt)
		else
			return getQuoteBTC(orderBook, 'bids', amt)
		end
	end

	
	def self.getQuoteUSD(orderBook, orderBookType, amt)
		btcPrice = HTTParty.get('https://www.bitstamp.net/api/ticker/')['last'].to_f

		price = 0
		book = orderBook[orderBookType]
		current_amt = (amt * btcPrice * 0.99)/btcPrice
		depth = 0

		while current_amt > 0
			if book[depth][1].to_f < current_amt
				price = price + (book[depth][0].to_f * book[depth][1].to_f)
				current_amt -= book[depth][1].to_f
			else
				price = price + (book[depth][0].to_f * current_amt)
				current_amt -= current_amt
			end
			depth += 1
		end
		return price
	end

	def self.getQuoteBTC(orderBook, orderBookType, amt)
		price = 0
		book = orderBook[orderBookType]
		current_amt = 0.99 * amt
		depth = 0

		while current_amt > 0
			if book[depth][0].to_f < current_amt
				price = price + book[depth][1].to_f
				current_amt -= book[depth][0].to_f
			else
				price = price + ((current_amt/book[depth][0].to_f) * book[depth][1].to_f)
				current_amt -= current_amt
			end
			depth += 1
		end
		return price
	end

end
