def pairs
	data = []

	data += add_suffix_to_pairs 'BTC', [
		'AMP',
		'ARDR',
		#'BCH',

		'BCY',
		'BELA',
		'BLK',
		'BTCD',
		'BTM',
		
		'BURST',

		#'CVC',
		
		'DCR',
		'DGB',

		'EMC2',


		'EXP',
		
		'FLDC',
		'FLO',
		'GAME',

		'GNO',
		'GNT',
		'GRC',
		'HUC',
		'LBC',
		'LSK',


		'NAUT',
		'NAV',
		'NEOS',
		
		'NOTE',
		'NXC',
		'NXT',

		'OMNI',
		
		'PINK',
		'POT',
		
		'RADS',
		'REP',
		'RIC',
		
		'SC',
		'SJCX',
		'STEEM',
		
		'STRAT',
		'SYS',
		'VIA',
		'VRC',
		'VTC',
		'XBC',
		'XCP',
		'XEM',

		'XPM',

		'XVC',

		#'ZRX'
	]
=begin
	add_suffix_to_pairs 'ETH', [
		BCH
		CVC
		ETC
		GAS
		GNO
		GNT
		LSK
		OMG
		REP
		STEEM
		ZEC
		ZRX
	]

	add_suffix_to_pairs 'XMR', [
		NXT
		DASH
		LTC
		ZEC
		BTCD
		BCN
		BLK
		MAID
	]

	add_suffix_to_pairs 'USDT', [
		BTC
		ETH
		BCH
		XRP
		LTC
		ZEC
		STR
		DASH
		ETC
		XMR
		NXT
		REP
	]
=end
	data
end

def add_suffix_to_pairs(suffix, pairs)
	pairs.map do |pair|
		"#{suffix}_#{pair}"
	end
end