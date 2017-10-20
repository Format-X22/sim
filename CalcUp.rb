require 'mongoid'
require 'active_support/core_ext/numeric/time'
require_relative 'Tick'
require_relative 'Pairs'

Mongoid.load!('./mongoid.yml', :development)


period = 5.minutes
clock = 1.day / period
skip = 1.months
total = 0

['BTC_STEEM'].each do |pair|
	Tick.collection = "#{pair}_#{period.to_i.to_s}"

	data = Tick.skip(skip / period).only(:open, :close, :high, :low, :avg).to_a.last(6.month / period)

	profit = 100
	elapsed = 0
	state = 'calc'
	low = Float::INFINITY
	open = 0
	close = 0
	sell_price = 0
	buy_price = 0
	buy = 0
	selled = false

	p data.size

	data.each do |tick|
		elapsed += 1

		next if tick.open < 0.00000500

		case state
			when 'calc'
				open ||= tick.open

				if tick.low < low
					low = tick.low
				end

				if elapsed == clock
					buy_price = low * 1.03
					low = Float::INFINITY
					elapsed = 0
					close = tick.close

					#if open > close
					#	sell_price = close * 1.03
					#else
					#	sell_price = open * 1.03
					#end

					state = 'buy'
				end
			when 'buy'
				if elapsed == clock
					elapsed = 0
					buy_price = 0
					open = tick.open
					close = 0
					state = 'calc'
				end

				if (tick.low..tick.high) === buy_price
					buy = buy_price * 1.0015
					state = 'sell'
				end
			when 'sell'
				if elapsed == clock
					elapsed = 0
					open = tick.open
					close = 0

					unless selled
						profit *= tick.avg / buy
					end

					selled = false
					state = 'calc'
				end

				if (tick.low..tick.high) === sell_price and !selled
					profit *= sell_price * 0.9985 / buy
					selled = true
				end
		end
	end

	p "#{pair} :: #{'%.2f' % profit}"

	total += profit
end

p '', ''
p "TOTAL >>> #{'%.2f' % (total)}"