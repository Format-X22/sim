class Wallet

	def initialize(btc, pairs)
		@wallet = {}

		pairs.each do |pair|
			@wallet[pair] = 0.0
		end

		@wallet[:BTC] = btc.to_f
	end

	def get(name)
		@wallet[name]
	end

	def set(name, val)
		@wallet[name] = val
	end

	def add(name, val)
		@wallet[name] += val
	end

	def mul(name, val)
		@wallet[name] *= val
	end

end