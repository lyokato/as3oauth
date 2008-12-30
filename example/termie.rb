#!/usr/bin/ruby

require 'rubygems'
require 'oauth/consumer'

consumer_key    = 'key'
consumer_secret = 'secret'
site            = 'http://term.ie'

consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {
:site               => 'http://term.ie',
:request_token_path => '/oauth/example/request_token.php',
:access_token_path  => '/oauth/example/access_token.php',
:authorize_path     => '/oauth/example/authorize.php',
:scheme             => :header,
:http_method        => :post
})

rtoken = consumer.get_request_token
p rtoken.token
p rtoken.secret

atoken = rtoken.get_access_token
p atoken.token
p atoken.secret

res = atoken.post('/oauth/example/echo_api.php');
p res.body
