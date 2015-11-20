#!/usr/bin/env ruby

#-------------------------------------------------
# get_issuu.rb - retrieve all jpg's for a document
#-------------------------------------------------

# 1. Open the issuu.com document in your web browser, as usual
#    example: http://issuu.com/iwishart/docs/thedivinity
# 2. Read the document page count; set variable $PAGES below
# 3. From browser menu, choose View > Source
# 4. Do a text search for "documentId" 
# 5. Copy string such as "081230122554-f76b0df1e7464a149caf5158813252d9" 
#    to $PUB variable below
# 6. Execute script:
#    ruby get_issuu.rb

require 'open-uri'
require 'rmagick'


def fetch_pdf(url)

    username = url.split("/")[3]
    docname = url.split("/")[5]
    query_url = "http://api.issuu.com/query?action=issuu.document.get_anonymous&format=json&documentUsername=#{username}&name=#{docname}&jsonCallback=C&_1341928054865="

    num_pages = open(query_url).read.split('pageCount":')[1].split(",")[0].to_i
    pub_hash = open(url).grep(/documentId/)[0].split("documentId=")[1].split('"')[0]

    for x in 1..num_pages do
      s_name = "page_#{x}.jpg"
      f_name = "tmp/page_#{"%03d" % x}.jpg"
      puts(Time.now.strftime('%Y-%m-%d %X') +" - Downloaded: "+ s_name +" >> "+ f_name)
      open(f_name,"wb").write(open("http://image.issuu.com/#{pub_hash}/jpg/#{s_name}").read)
    end
    puts("#{Time.now.strftime('%Y-%m-%d %X')} - All pages have been downloaded")

    Dir["tmp/*.jpg"].each { |filename| 
            im = Magick::Image.read(filename)
            im[0].write(filename + ".pdf")
        }

    `pdftk tmp/*.pdf cat output issue.pdf`
    `rm tmp/*.jpg`
    `rm tmp/page*.pdf`
end


fetch_pdf("http://issuu.com/teemuarina/docs/biohackers_handbook-sleep_9f915fcce3c2fd")



#$PUB="120602085552-1d7234d1c80d4bc6986ed7468f19c3ca"
#$URL = "http://issuu.com/edicomedizioni/docs/az_04_x_issuu"
#$URL = "http://issuu.com/rwdmag/docs/digital_magazine_july"
#$PAGES=44

# puts open("http://issuu.com/edicomedizioni/docs/az_04_x_issuu").read.grep("/documentId/")

# sudo gem install pdf-toolkit --http-proxy http://localhost:3128
# sudo gem install pdf-merger --http-proxy http://localhost:3128

# mkdir pdf
# for file in $(ls *.jpg); do convert $file pdf/$file.pdf ; done
# pdftk *.pdf cat output join.pdf
