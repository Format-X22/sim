require 'mongoid'
require 'active_support'
require_relative 'Tick'

Mongoid.load!('./mongoid.yml', :development)

def ticks(pair, from, count)
	Tick.collection = "#{pair}_#{1.day.to_i.to_s}"
	Tick
		.skip(1.month / 1.day)                   # safe margin
		.only(:open, :close, :high, :low, :avg)
		.to_a
		.last(from / 1.day)[0...(count / 1.day)]
end

pairs = %w[
	AMP BCY BELA BLK BTCD BTM DCR EXP GAME GRC HUC LBC LSK NAUT NAV NEOS
	NOTE NXT OMNI POT RADS RIC SJCX STEEM SYS VIA VRC VTC XBC XCP XPM XVC
].map {|v| "BTC_#{v}"}

extracted = []
pairs.each do |pair|
	extracted << {name: pair, data: ticks(pair, 10.month, 6.month)}
end

formed = []
data_len = extracted[0][:data].length

(0...data_len).each do |index|
	extracted.each do |pair|
		formed[index] ||= []
		formed[index] << {
			name: pair[:name],
			tick: pair[:data][index]
		}
	end
end

instruction = []

formed.each do |pack|
	mapped = pack.map do |data|
		{
			name: data[:name],
			val: data[:tick].close / data[:tick].open
		}
	end

	sorted = mapped.sort do |a, b|
		a[:val] <=> b[:val]
	end

	slice = sorted[15..21]

	instruction << slice.map do |inst|
		inst[:name]
	end
end

total = 100

instruction[0..-2].each.with_index do |inst, index|
	profit = 0

	inst.each do |pair_name|
		pair = extracted.select {|v| v[:name] == pair_name}
		tick = pair[0][:data][index + 1]

		buy_com = 1.015
		sell_com = 0.985

		if index != 0 and instruction[index - 1].include? pair_name
			buy_com = 1
		end

		if instruction[index + 1].include? pair_name
			sell_com = 1
		end

		profit += ((tick.close * sell_com) / (tick.open * buy_com)) / inst.length
	end

	total *= profit
end

p "TOTAL >>> #{'%.2f' % total}"