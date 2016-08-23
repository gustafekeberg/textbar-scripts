#!/usr/bin/env ruby -E utf-8
#<Encoding:UTF-8>

require 'rubygems'
require 'yaml'
require 'fileutils'

# require 'open-uri'
# require 'xmlsimple'

config = {
	"title" => "⭐",
	"divider" => "---",
	"edit_text" => "Edit",
}

default_conf_file = "#{ENV['HOME']}/.textbar-scripts-config/bookmarks.yaml"
input = ARGF.argv
if ENV['TEXTBAR_INDEX']
	textbar_index = ENV['TEXTBAR_INDEX'].to_i
end

unless input[0]
	config_file = default_conf_file
else
	config_file = input[0]
end
config = config.merge( YAML.load_file( config_file ) )

@title = config["title"]
@divider = config["divider"]
@edit = config["edit"]

def make_list ( list )
	array = []
	list.each do |l|
		unless l == "--"
			array.push( l["name"] )
		else
			array.push( @divider )
		end
	end
	return array
end


if textbar_index
	item = config["list"][textbar_index - 1]
	puts config["list"].length
	if textbar_index == config["list"].length + 2
		`$EDITOR '#{config_file}'`
	elsif item != "--" || textbar_index != config["list"].length + 2
		`/usr/bin/open #{item["url"]}`
	end
else
	list = make_list( config["list"] )

	puts @title
	puts list
	puts @divider
	puts @edit
end
