require 'mongoid'
require 'active_support/core_ext/numeric/time'
require_relative 'Tick'
require_relative 'Pairs'

Mongoid.load!('./mongoid.yml', :development)


period = 5.minutes
skip = 1.months
percent = 97.0
wait_origin = 7.days / period
total = 0.0

pairs.each do |pair|
	Tick.collection = "#{pair}_#{period.to_i.to_s}"

	data = Tick.skip(skip / period).only(:open, :close, :low, :high).to_a.last(3.month / period)

	profit = 100
	state = 'buy'
	wait = 0
	buy = 0
	low = Float::INFINITY

	data.each_with_index do |tick, index|
		next if tick.open < 0.00000500

		last = data[index - 1]
		low ||= tick.low

		if low > tick.low
			low = tick.low
		end

		case state
			when 'buy'
				if last.open > last.close
					buy = tick.open * 1.0015
					state = 'wait'
				end
			when 'wait'
				if low * (1 + percent / 100) < tick.high
					profit *= (low * (1 + percent / 100) * 0.9985) / buy
					state = 'calm'
				end
			when 'calm'
				wait -= 1

				if wait < 0
					wait = wait_origin
					low = Float::INFINITY
					state = 'buy'
				end
		end
	end

	if state == 'wait'
		profit *= (data.last.open * 0.9975) / buy
	end

	p "#{pair} :: #{'%.2f' % profit}"

	total += profit
end

p '', ''
p "TOTAL >>> #{'%.2f' % (total / pairs.length)}"