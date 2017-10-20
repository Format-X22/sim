require_relative 'Main'

pairs = [
	'AMP',
	'BCY',
	'BELA',
	'BLK',
	'BTCD',
	'BTM',
	'DCR',
	'EXP',
	'GAME',
	'GRC',
	'HUC',
	'LBC',
	'LSK',
	'NAUT',
	'NAV',
	'NEOS',
	'NOTE',
	'NXT',
	'OMNI',
	'POT',
	'RADS',
	'RIC',
	'SJCX',
	'STEEM',
	'SYS',
	'VIA',
	'VRC',
	'VTC',
	'XBC',
	'XCP',
	'XPM',
	'XVC'
].map {|v| "BTC_#{v}".to_sym}

#