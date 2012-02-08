# encoding: utf-8
require 'sinatra'
require 'memcached'

$cache = Memcached.new("localhost:11211")

get '/' do
    "Welcome to the WIO API!"
end

get '/wio' do
    $cache.get 'wio'
end

get '/wio/:id' do
    :id
end

post '/wio/:id' do
    list = $cache.get 'wio'
    unless list.include? :id
        list << :id
        "User #{:id} added."
    end
    "User #{:id} already exists."
end

delete '/wio/:id' do
    list = $cache.get 'wio'
    list.gsub! :id, ""
end
