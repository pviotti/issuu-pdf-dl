# issuu-pdf-dl

A simple tool to download documents from issuu.com as PDFs.

> When using this tool please make sure to respect [Issuu's TOS](https://issuu.com/legal/terms).

:warning: Following changes to Issuu's web site, this tool doesn't work anymore.
I'm considering fixing it (and perhaps rewriting it in another language),
but can't provide an ETA at the moment. PRs are welcome. https://github.com/pviotti/issuu-pdf-dl/issues/9


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

