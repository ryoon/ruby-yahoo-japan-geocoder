# Yahoo! Japan geocoder API application written in Ruby language

API specification is described at
https://developer.yahoo.co.jp/webapi/map/openlocalplatform/v1/geocoder.html .

Usage:

Prepare input TSV file in UTF-8 without BOM.

	$ cd /usr/pkgsrc/www/ruby-rest-client
	$ make RUBY_VERSION_DEFAULT=24 install
	$ cd ~/ruby-yahoo-japan-geocoder
	$ ruby24 ./ruby-yahoo-geocoder.rb testinput.txt output.txt
