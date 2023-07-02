# issuu-pdf-dl

A simple tool to download documents from issuu.com as PDFs.

> When using this tool please make sure to respect [Issuu's TOS](https://issuu.com/legal/terms).


## Setup

```bash
$ python -m venv venv
$ source venv/bin/activate
$ pip install -r requirements.txt
```

## Usage

```bash
$ ./issuu-pdf-dl.py http://issuu.com/user_name/docs/doc_name -o ./output.pdf
```

Help message:
```bash
$ ./issuu-pdf-dl.py --help
usage: Download Issuu documents as PDF.

positional arguments:
  document_url          URL of the document to download

options:
  -h, --help            show this help message and exit
  --output OUTPUT, -o OUTPUT
                        output file path
```

## License

[WTFPL](http://www.wtfpl.net/)

