require_relative 'Requires'

class Main

	def initialize(btc, pairs, period, from, count, margin = 1.month)
		@pairs = pairs
		@extractor = PairData.new(period, margin, from, count)
		@wallet = Wallet.new(btc, pairs)

		iterate(count / period)
		print_result
	end

	def extract_data
		@pairs.map do |pair|
			{
				name: pair,
				data: @extractor.get_data(pair)
			}
		end
	end

	def iterate(iterations)
		calculator = Calculator.new(@wallet, extract_data)

		(0..iterations).each do |index|
			calculator.calc(index)
		end

		calculator.finalize
	end

	def print_result
		p '%.2f' + @wallet.get(:BTC)
	end

end