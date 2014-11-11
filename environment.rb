require 'mongo_mapper'
require 'pry'
require 'csv'
require 'sidekiq'
require 'sinatra'
require 'rest_client'
require 'nokogiri'
require 'csv'
require 'pry'

MongoMapper.connection = Mongo::MongoClient.new("0.0.0.0", 27017, :pool_size => 25, :pool_timeout => 60)
MongoMapper.database = "kotaku_in_action"
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/extensions/*.rb'].each {|file| require file }
Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

