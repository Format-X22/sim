require 'mongoid'

class Tick
	include Mongoid::Document

	field :date,   type: Integer
	field :high,   type: Float
	field :low,    type: Float
	field :open,   type: Float
	field :close,  type: Float
	field :volume, type: Float
	field :quote,  type: Float
	field :avg,    type: Float

	store_in collection: ''

	def self.collection=(val)
		store_in collection: val
	end
end