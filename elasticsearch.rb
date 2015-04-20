#!/usr/local/bin/ruby

require 'rubygems'
require 'json'
require 'net/http'

es_index="index_monitor"
es_host ||= ARGV[0] || 'localhost'
es_porta=9200

http = Net::HTTP.new("#{es_host}", es_porta)

stats = http.send_request("GET", "/_nodes/stats?all")
stats = JSON.parse(stats.body)

nodes = stats['nodes']
nodes.each do |key,value|
	payload = ""
	node_name = value['name']
			
	payload += '{"index": {"_index": "' + es_index + '", "_type": "' + node_name + '"}}' + "\n"
	payload += value.to_json + "\n"

	http.send_request("POST", "/_bulk", data=payload)
end
					
