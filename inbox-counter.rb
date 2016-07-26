#!/usr/bin/env ruby -E utf-8
#<Encoding:UTF-8>

require 'rubygems'
require 'net/imap'
require 'yaml'
require 'fileutils'

# Setup

default_conf_file = "#{ENV['HOME']}/.textbar-scripts-config/inbox-counter.yaml"
config = {
	"title" => "",
	"unreadicon" => "✉ ",
	"emptyicon" => "✉ ",
	"unreachable" => "❗️",
	"show_empty" => false,
}

# Variables

conf_vars = {}
args = ARGF.argv
total_unread = 0
if ENV['TEXTBAR_INDEX']
	textbar_index = ENV['TEXTBAR_INDEX'].to_i
end

@urls = {
	"google_gmail" => "https://mail.google.com/mail/u/?authuser=",
	"google_inbox" => "https://inbox.google.com/u/?authuser=",
	"google_feed" => "https://mail.google.com/mail/feed/atom",
}


# Functions

def read_inbox ( account )
	user = account['username']
	pass = account['password']
	port = account['port']
	ssl = account['ssl']

	status = {}
	begin
		server = account['imap']
		imap = Net::IMAP.new(server, port, ssl)
		imap.login(user, pass)
		status = imap.status(account['mailbox'], ["UNSEEN"])
		imap.disconnect
	rescue
	end
	return status['UNSEEN']
end

# Script

args.map.with_index do |l, i|
	n = i + 1
	if l[0] == '-' && l.length == 2 && args[n]
		conf_vars[l[1]] = args[n]
	end	
end

# Read config from file
if conf_vars['c']
	config = config.merge ( YAML.load_file( conf_vars['c'] ) )
elsif default_conf_file
	config = config.merge( YAML.load_file( default_conf_file ) )
end

status_unreachable_all = config['unreachable']
accounts = config['accounts']

# Open inbox if textbar_index is set
if textbar_index
	account = accounts[textbar_index - 1]
	view = account['view']
	`/usr/bin/open #{view}`

# Else get inbox data if accounts in config
elsif accounts.length > 0
	count_output = []
	threads = []
	accounts.map.with_index do |l, i|
		threads << Thread.new {
			begin
				count = read_inbox( accounts[i] )
				total_unread += count
				status_unreachable_all = ""
				count_output[i] = "#{count}\t#{accounts[i]['display']}"
			rescue
				count_output[i] = "#{config['unreachable']}\t#{accounts[i]['display']}"
			end
		}
	end
	threads.each { |thr| thr.join }

	# Prepare output
	icon = config['unreadicon']
	title = config['title']

	if total_unread == 0
		icon = config['emptyicon']
		unless config['show_empty']
			total_unread = ''
		end
	end

	# Output
	puts "#{title}#{icon}#{status_unreachable_all}#{total_unread}"
	puts count_output
end
