class PairData

	def initialize(period, margin, from, count)
		@period = period
		@period_string = @period.to_i.to_s
		@safe_time = margin / @period
		@from = from / @period
		@count = count / @period
	end

	def get_data(pair)
		Tick.collection = "#{pair.to_s}_#{@period_string}"
		Tick.skip(@safe_time).to_a.last(from)[0...(count)]
	end
end