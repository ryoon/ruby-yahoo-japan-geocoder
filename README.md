# Yahoo! Japan geocoder API application written in Ruby language

API specification is described at
https://developer.yahoo.co.jp/webapi/map/openlocalplatform/v1/geocoder.html .

Usage:

Prepare input TSV file in UTF-8 without BOM.

	$ cd /usr/pkgsrc/www/ruby-rest-client
	$ make RUBY_VERSION_DEFAULT=25 install
	$ cd ~/ruby-yahoo-japan-geocoder
	$ ruby25 ./ruby-yahoo-geocoder.rb testinput.txt output.txt

Or for JRuby, install JRuby and:

	$ cd ~/ruby-yahoo-japan-geocoder
	$ jruby -S gem install bundler
	$ jruby -S bundle install --path vendor/bundle
	$ jruby -S bundle exec jruby -E utf-8 ./ruby-yahoo-geocoder.rb testinput.txt output.txt
