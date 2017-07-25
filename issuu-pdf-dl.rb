#!/usr/bin/env ruby
# Download documents from issuu.com as PDF

require 'open-uri'
require 'rmagick'


def fetch_pdf(url)
    username = url.split("/")[3]
    docname = url.split("/")[5]
    query_url = "http://api.issuu.com/query?action=issuu.document."\
                "get_anonymous&format=json&"\
                "documentUsername=#{username}&name=#{docname}&jsonCallback=C&_1341928054865="

    num_pages = open(query_url).read.split('pageCount":')[1].split(",")[0].to_i
    pub_hash = open(url).grep(/documentId/)[0].split('documentId":"')[1].split('"')[0]
    
    begin
        dir = Dir.mktmpdir
        
        for x in 1..num_pages do
          open("#{dir}/page_#{"%03d" % x}.jpg","wb")
            .write(open("http://image.issuu.com/#{pub_hash}/jpg/page_#{x}.jpg").read)
          puts(Time.now.strftime('%Y-%m-%d %X') +" - Downloaded: page_#{x}.jpg")
        end
        puts("#{Time.now.strftime('%Y-%m-%d %X')} - All pages have been downloaded.")

        Dir["#{dir}/*.jpg"].each { |filename| 
            begin
                im = Magick::Image.read(filename)
                im[0].write(filename + ".pdf")
            rescue
                puts("Error converting #{filename} to PDF.")
            end
            }

        `pdftk #{dir}/*.pdf cat output #{docname}.pdf`
        puts("#{Time.now.strftime('%Y-%m-%d %X')} - #{docname}.pdf has been created successfully.")
    ensure
        # remove the tmp directory
        FileUtils.remove_entry_secure dir
    end
end

if __FILE__ == $0
    if ARGV.length == 0 then
        puts "Usage: #{$0} <issue.com URL>"
        exit 1
    end
    fetch_pdf(ARGV[0])
end
