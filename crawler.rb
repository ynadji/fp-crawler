#!/usr/bin/env ruby -w
# 
# Crawls pages, woo!

require 'rubygems'
require 'trollop'
require 'google'

KEY = File.open("gkey") {|kf| kf.readline.chomp}
google = Google::Search.new(KEY)

$cli_options = Trollop::options do
	opt :browse, "Launch the Browser"
	opt :download, "Download the HTML Files"
	opt :terms, "Terms File", :default => "terms.rdf.u8"
end

def get_terms(terms_file)
	found_topic = false
	topic = nil

	infile = File.open(terms_file, 'r')

	infile.each_line do |line|
		if line =~ /<Topic r:id="Top\/(\w+?)">/
			found_topic = true
			topic = $1
			puts topic

			next
		elsif line == "</Topic>"
			found_topic = false

			next
		end

		if found_topic
			query = nil
			if line =~ /<d:term>(.+?)<\/d:term>/
				query = $1
			end

			if query
				#puts "Running search..."
				#puts "Query: #{query}"
				#run_search(query, google)
			end
		end
	end
end

def run_search(query, google)
	res = google.search(query)

	if $cli_options[:browse]
		`konqeuror #{res['url']}`
	elsif $cli_options[:download]
		`wget #{res['url']}`
	else
		puts res['url']
	end
end

get_terms($cli_options[:terms])
