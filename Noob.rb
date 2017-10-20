require 'mongoid'
require 'active_support/core_ext/numeric/time'
require_relative 'Tick'
require_relative 'Pairs'

Mongoid.load!('./mongoid.yml', :development)


period = 2.hours
skip = 1.months
total = 0

['BTC_LTC'].each do |pair|
	Tick.collection = "#{pair}_#{period.to_i.to_s}"

	data = Tick.skip(skip / period).only(:open, :close, :low, :high).to_a.last(3.month / period)

	profit = 100
	state = 'buy'
	buy = 0

	data.each do |tick|
		next if tick.open < 0.00000500

		case state
			when 'buy'
				if tick.open < tick.close
					buy = tick.close * 1.0025
					state = 'sell'
				end
			when 'sell'
				if tick.open > tick.close
					p "#{tick.close * 0.9975} / #{buy}"

					profit *= tick.close * 0.9975 / buy
					state = 'buy'
				end
		end
	end

	p "#{pair} :: #{profit}"

	total += profit
end

p '', ''
p "TOTAL >>> #{total}"