require 'mongoid'
require 'active_support/core_ext/numeric/time'
require_relative 'Tick'
require_relative 'Pairs'

Mongoid.load!('./mongoid.yml', :development)


period = 4.hours
skip = 1.months
total = 0
buy_com = 1.0025
buy_soft_com = 1.0015
sell_soft_com = 0.9985
sell_com = 0.9975
co = 0.97

#pairs_slice = ['BTC_LTC']
pairs_slice = pairs

pairs_slice.each do |pair|
	Tick.collection = "#{pair}_#{period.to_i.to_s}"

	data = Tick.skip(skip / period).only(:open, :close, :high, :low).to_a.last(1.month / period)

	profit = 100

	data.each_with_index do |tick, index|
		next if tick.open < 0.00000500
		next if index < 3

		buy = data[index - 1]
		sell = tick
		
		buy_price = buy.low * co

		if sell.low < buy.low * co
			profit *= (sell.close * sell_soft_com) / (buy_price * buy_soft_com)
		end
	end

	p "#{pair} :: #{'%.2f' % profit}"

	total += profit
end

p '', ''
p "TOTAL >>> #{'%.2f' % (total / pairs_slice.length)}"