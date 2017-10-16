require 'json'
require 'http'
require 'mongoid'
require 'active_support/core_ext/numeric/time'
require_relative 'Pairs'
require_relative 'Times'
require_relative 'Tick'

Mongoid.load!('./mongoid.yml', :development)

url = 'https://poloniex.com/public?command=returnChartData'

start = 2.years.ago.to_i
stop = DateTime.now.to_time.to_i
period = 5.minutes.to_i.to_s

pairs.each do |pair|
	full_url = "#{url}&currencyPair=#{pair}&start=#{start}&end=#{stop}&period=#{period}"
	Tick.collection = pair + '_' + period

	sleep 1

	begin
		data = JSON.parse(HTTP.get(full_url).to_s)
	rescue
		p 'HTTP Error'
		sleep 3

		begin
			data = JSON.parse(HTTP.get(full_url).to_s)
		rescue
			p 'HTTP Error again!'
			sleep 7

			begin
				data = JSON.parse(HTTP.get(full_url).to_s)
			rescue
				p 'HTTP Error, last try...'
				sleep 15
				data = JSON.parse(HTTP.get(full_url).to_s)
			end
		end
	end

	data.map! do |tick|
		{
			date:   tick['date'],
			high:   tick['high'],
			low:    tick['low'],
			open:   tick['open'],
			close:  tick['close'],
			volume: tick['volume'],
			quote:  tick['quoteVolume'],
			avg:    tick['weightedAverage']
		}
	end

	Tick.collection.drop
	Tick.collection.insert_many(data)

	p "done #{pair}"
end

p 'Success!'