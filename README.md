# issuu-pdf-dl

A simple tool to download documents from issuu.com as PDFs,
even when the download option is not available.

## Requirements

 - Ruby (>1.8)
 - ImageMagick and its Ruby bindings
 - PDFtk

On a recent version of Ubuntu you can install all required software with this command:

    sudo apt-get install ruby ruby-rmagick pdftk 

## Usage

    ./issuu-pdf-dl.rb <URL>
    
Example URL: `http://issuu.com/user_name/docs/doc_name`

It downloads the pages of the document in a temporary directory 
and outputs the PDF in the current directory.


## License

[WTFPL](http://www.wtfpl.net/)

