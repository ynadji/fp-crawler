#!/usr/bin/env ruby -w
#
# Grabs top 500 global sites from alexa.com

require 'open-uri'

1.upto(5) do |pg_number|
	str = open("http://www.alexa.com/site/ds/top_sites?ts_mode=global&lang=none&page=#{pg_number}").read
	urls = str.scan(/>(http:\/\/|www.+?)</).flatten
	puts urls
end
