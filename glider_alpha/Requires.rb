require 'mongoid'
require 'active_support'
require_relative 'Tick'
require_relative 'PairData'
require_relative 'Wallet'

Mongoid.load!('./mongoid.yml', :development)