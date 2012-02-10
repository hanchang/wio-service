# encoding: utf-8
require 'sinatra'
require 'memcached'
require 'json'

class WIO < Sinatra::Application
end

ENV['RACK_ENV'] == "production" ? $cache = Memcached.new() : $cache = Memcached.new("192.168.1.232:11311") 

get '/' do
    "Welcome to the WIO API!"
end

get '/flush' do
    $cache.flush
end

get '/wio' do
    list = retrieveWIO
    content_type :json
    list.to_json
end

get '/wio/:id' do
    :id.to_json
end

post '/wio/:id' do
    list = retrieveWIO
    unless list.include? params[:id]
        list << params[:id]
        $cache.set 'wio', list
        return "User #{params[:id]} added."
    end
    
    "User #{:id} already exists."
end

delete '/wio/:id' do
    list = retrieveWIO
    if list.delete(params[:id]) == nil
        return "No user #{params[:id]} found, cannot delete."
    end

    $cache.set 'wio', list
    "User #{params[:id]} deleted."
end

def retrieveWIO
    begin
        list = $cache.get 'wio'
    rescue ::Memcached::NotFound
        $cache.set 'wio', []
        list = []
    end

    return list
end
