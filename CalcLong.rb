require 'mongoid'
require 'active_support/core_ext/numeric/time'
require_relative 'Tick'
require_relative 'Pairs'

Mongoid.load!('./mongoid.yml', :development)

period = 1.day
total = 0

def get_tick(date)
	Tick.where(date: DateTime.parse(date).to_time.to_i).first
end

def get_btc_cost(date)
	collection = Tick.collection_name
	Tick.collection = "USDT_BTC_#{1.day.to_i.to_s}"
	avg = Tick.where(date: DateTime.parse(date).to_time.to_i).first.avg
	Tick.collection = collection

	avg
end

pairs.each do |pair|
	Tick.collection = "#{pair}_#{period.to_i.to_s}"

	profit2017 = 0
	start2017 = get_tick('20/01/2017')
	end2017 = get_tick('26/06/2017')

	if start2017

		profit2017 = end2017.avg / start2017.avg

		p "#{pair} :: 2017 = #{profit2017}"
	end

	total += profit2017 * 100
end

start_btc = get_btc_cost('20/01/2017')
end_btc = get_btc_cost('26/06/2017')

p (total / pairs.length)
p (total / pairs.length) * (end_btc / start_btc)
p end_btc / start_btc