$:.unshift File.expand_path("../..", __FILE__)

require 'dearchiver'
require 'simplecov'

SimpleCov.start do
  add_group 'DeArchiver', 'lib/dearchiver'
end