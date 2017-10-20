require 'mongoid'
require 'active_support/core_ext/numeric/time'
require_relative 'Tick'
require_relative 'Pairs'

Mongoid.load!('./mongoid.yml', :development)

period = 5.minutes
deadline = 1.day / period
skip = 1.months
total = 0

pairs.each do |pair|
	data = ticks(pair, skip, period)
	profit = 100
	elapsed = 0
	state = 'calc'

	low = infinity
	open = 0
	close = 0

	buy = 0
	sell = true
	buy_price = 0
	sell_price = 0

	data.each do |tick|
		#
	end
end

def ticks(pair, skip, period)
	Tick.collection = "#{pair}_#{period.to_i.to_s}"
	Tick.skip(skip / period).only(:open, :close, :high, :low, :avg).to_a
end

def infinity
	Float::INFINITY
end