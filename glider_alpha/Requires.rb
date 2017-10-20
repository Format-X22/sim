require 'mongoid'
require 'active_support'
require_relative 'Tick'
require_relative 'PairData'
require_relative 'Wallet'
require_relative 'Calculator'

Mongoid.load!('./mongoid.yml', :development)