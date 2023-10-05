#!/bin/bash

convert_dnsmasq() {
	local source_name="$1"
	local source_url="$2"
	local output_file="$3"

	mkdir -p ./temp/
	echo "⌛ Downloading $source_name from $source_url ..."
	curl -sSL $source_url > ./temp/dnsmasq.conf
	# local count=$(grep -c '^\(address\|local\|server\)=/' ./temp/dnsmasq.conf)
	local date=$(date -u '+%a %b %d %T %Z %Y')

	# Process
	echo "⌛ Converting ..."
	cat ./temp/dnsmasq.conf  | grep -oE '^(address|local|server)=/[^/]+/' | sed -E 's/(address|local|server)=//; s|/||g' | awk '{print "\"+."$1"\""}' | awk '{a[NR]=$0} END{print "payload:\n" "  " "- " a[1]; for (i=2; i<=NR; i++) print "  " "- " a[i]}' > $output_file

	# Alternative count
	local count=$(grep -c '^\s\s-' $output_file)
	echo "✨ $count rules converted!"
	
	# Generate new comment
	local comment="# Source: $source_name ($source_url)"
	comment="$comment\n# Behavior: domain"
	comment="$comment\n#"
	comment="$comment\n# Blocked domains: $count"
	comment="$comment\n# Updated at: $date"
	comment="$comment\n"
	sed -i "1i$comment" $output_file
	echo "👌 Output: $output_file"
	rm -rf ./temp
}

convert_dnsmasq $1 $2 $3