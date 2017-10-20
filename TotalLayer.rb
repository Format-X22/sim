require 'mongoid'
require 'active_support'
require_relative 'Tick'
require_relative 'Pairs'

Mongoid.load!('./mongoid.yml', :development)

def ticks(pair, skip, period)
	Tick.collection = "#{pair}_#{period.to_i.to_s}"
	Tick.skip(skip / period).only(:open, :close, :high, :low, :avg).to_a
end

def extract_pairs
	pairs_data = []

	[
		"BTC_AMP",
		"BTC_BCY",
		"BTC_BELA",
		"BTC_BLK",
		"BTC_BTCD",
		"BTC_BTM",
		#"BTC_BURST",
		"BTC_DCR",
		#"BTC_DGB",
		#"BTC_EMC2",
		"BTC_EXP",
		#"BTC_FLDC",
		#"BTC_FLO",
		"BTC_GAME",
		"BTC_GRC",
		"BTC_HUC",
		"BTC_LBC",
		"BTC_LSK",
		"BTC_NAUT",
		"BTC_NAV",
		"BTC_NEOS",
		"BTC_NOTE",
		"BTC_NXT",
		"BTC_OMNI",
		#"BTC_PINK",
		"BTC_POT",
		"BTC_RADS",
		"BTC_RIC",
		#"BTC_SC",
		"BTC_SJCX",
		"BTC_STEEM",
		"BTC_SYS",
		"BTC_VIA",
		"BTC_VRC",
		"BTC_VTC",
		"BTC_XBC",
		"BTC_XCP",
		#"BTC_XEM",
		"BTC_XPM",
		"BTC_XVC"
	].each do |pair|
		data = ticks(pair, 1.month, 1.day).last(10.month / 1.day)[0...(6.month/1.day)]

		#if data.length == 365
			pairs_data << data
		#end

		if data[0].open < 0.00000500
			#p pair
		end
	end

	pairs_data
end

def reformat_pairs
	extracted = extract_pairs
	result = []

	(0...(extracted[0].length)).each do |index|
		extracted.each do |pair|
			result[index] ||= []
			result[index] << pair[index]
		end
	end

	result
end

total = 100
packs = reformat_pairs

packs.each_with_index do |pack, index|
	next if index == 0

	last = packs[index - 1]
	cur = pack
	profit = 0

	mapped = last.map.with_index {|tick, i| {val: tick.close / tick.open, index: i}}
	sorted = mapped.sort {|a, b| a[:val] <=> b[:val]}
	#slice = sorted[(pack.length.to_f / 3)..(pack.length.to_f / 1.5)]
	slice = sorted[15..21]

	slice.each do |co|
		tick = cur[co[:index]]
		profit += (tick.close * 0.9975) / (tick.open * 1.0025)
	end

	total *= profit / slice.length
end

p total