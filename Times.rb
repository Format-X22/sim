require 'active_support/core_ext/numeric/time'

def times
	[
		5.minutes,
		15.minutes,
		30.minutes,
		2.hours,
		4.hours,
		1.day
	].map(&:to_i)
end