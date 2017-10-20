require_relative 'Requires'

class Main

	def initialize(btc, pairs, period, from, count, margin = 1.month)
		@wallet = Wallet.new(btc, pairs)
		@pair_data = PairData.new(period, margin, from, count)
		@iterations = (count / period).to_i

		run
	end

	def run
		(0..@iterations).each do |index|
			# TODO
		end
	end

end