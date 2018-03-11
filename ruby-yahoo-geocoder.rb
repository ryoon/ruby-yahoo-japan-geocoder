# Yahoo! Japan geocoder in Ruby
#
# Usage:
# $ ruby24 ./ruby-yahoo-geocoder.rb input.txt output.txt
#
# Copyright (c) 2017, 2018 Ryo ONODERA <ryo@tetera.org>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# API is described at
# https://developer.yahoo.co.jp/webapi/map/openlocalplatform/v1/geocoder.html

require 'rest-client'
require 'rexml/document'
require 'csv'

# base URI
baseurl = 'https://map.yahooapis.jp/geocode/V1/geoCoder'

# Yahoo! Japan API key
appid = 'YOUR_APPLICATION_ID' # Required

# Address search level
search = '4'

# address range: 'le'means 'less than or equal'
level = 'le'

# Fall back to upper search level
recursive = 'true'

# Result format
format = 'xml'

# Fallback coordinate
fallback_latitude = '0'
fallback_longitude = '0'

ofile = File.open(ARGV[1], 'w')

puts "Start"

begin
  cvsdata = CSV.read(ARGV[0], col_sep: "\t", headers: true)
  cvsdata.each do |row|
    code = row[0]
    addr = row[2]
    url = baseurl + '?' + 'appid=' + appid + '&al=' + search +
          '&ar=' + level + '&recursive=' + recursive +
          '&output=' + format +
          '&query=' + addr
    eurl = URI.escape(url)
    puts 'Processing: ' + addr
    RestClient.get(eurl) { |response, request, result, &block|
      case response.code
      when 200
        doc = REXML::Document.new response.body
        coordinates = doc.elements['YDF/Feature[1]/Geometry/Coordinates']
        if (coordinates != nil)
          pcoordinates = coordinates.text()
          tsv = pcoordinates.gsub(',', '	')
        else
          tsv = fallback_latitude + '	' + fallback_longitude
        end
        otsv = code + '	' + tsv
        ofile.puts otsv
      else
        puts 'HTTP error code: '
        puts response.code
      end
    }
    end
rescue SystemCallError => e
  puts %Q(class=[#{e.class}] message=[#{e.message}])
rescue IOError => e
  puts %Q(class=[#{e.class}] message=[#{e.message}])
end

ofile.close
puts 'End'
