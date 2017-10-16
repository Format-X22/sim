require 'mongoid'
require 'active_support/core_ext/numeric/time'
require_relative 'Tick'
require_relative 'Pairs'

Mongoid.load!('./mongoid.yml', :development)


period = 1.day
skip = 1.months
percent = 97
wait_origin = 7
total = 0

pairs.each do |pair|
	Tick.collection = "#{pair}_#{period.to_i.to_s}"

	data = Tick.skip(skip / period).only(:open, :low, :high).to_a

	profit = 100
	state = 'buy'
	wait = 0
	buy = 0
	low = nil

	data.each do |tick|
		next if tick.open < 0.00000500

		low ||= tick.low

		if tick.low < low
			low = tick.low
		end

		case state
			when 'buy'
				buy = tick.open * 1.0015
				state = 'wait'
			when 'wait'
				if low * (1 + percent / 100) < tick.high
					profit *= (low * (1 + percent / 100) * 0.9995) / buy
					state = 'calm'
				end
			when 'calm'
				if wait < 0
					wait = wait_origin
				end

				wait -= 1

				if wait < 0
					state = 'buy'
				end
		end
	end

	if state == 'wait'
		profit *= (data.last.open * 0.9995) / buy
	end



	p "#{pair} :: #{profit}"

	total += profit
end

p '', ''
p "TOTAL >>> #{total}"