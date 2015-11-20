# issuu-pdf-dl

A make-do simple tool to download as PDFs documents on issuu.com without a download option.

## Requirements

 - Ruby (>1.8)
 - ImageMagick and its Ruby bindings
 - PDFtk

On a recent version of Ubuntu you can install all requirements with this command:

    sudo apt-get install ruby ruby-rmagick pdftk 

## Usage

    ./issuu-pdf-dl.rb <URL>
    
Example URL: `http://issuu.com/user_name/docs/doc_name`

The document is downloaded in `/tmp` and gets assembled as PDF in the current directory.


## License

[WTFPL](http://www.wtfpl.net/)

