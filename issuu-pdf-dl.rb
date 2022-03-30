#!/usr/bin/env ruby
# Download documents from issuu.com as JPGs and convert them to PDF

require 'open-uri'
require 'rmagick'
require 'tmpdir'
require 'json'

def fetch_pdf(url)
    username = url.split("/")[3]
    docname = url.split("/")[5]
    pub_hash = URI.open(url).grep(/image.isu.pub/)[0].split('<meta name="twitter:image" content="https://image.isu.pub/')[1].split('/jpg/page_1.jpg">')[0]
    query_url = "https://search.issuu.com/api/2_0/documents?documentId=#{pub_hash}&responseParams=pagecount"

    json_data = JSON.parse(URI.open(query_url).read)
    num_pages = json_data['response']['docs'][0]['pagecount'].to_i

   begin
        dir = Dir.mktmpdir

        for x in 1..num_pages do
          open("#{dir}/page_#{"%03d" % x}.jpg","wb")
            .write(URI.open("http://image.issuu.com/#{pub_hash}/jpg/page_#{x}.jpg").read)
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