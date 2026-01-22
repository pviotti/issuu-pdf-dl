#!/usr/bin/env python3
import gzip
import json
import os
import urllib.request
from argparse import ArgumentParser
from io import BytesIO
from typing import List

from PIL import Image
from pypdf import PdfReader, PdfWriter
from tqdm import tqdm


def retrieve_images_from_urls(url_list: List[str]) -> list[Image.Image]:
    """Returns a list of in-memory images retrieved from HTTP URLs."""
    images = []
    for url in tqdm(url_list, desc="Downloading images"):
        try:
            with urllib.request.urlopen(url) as response:
                image_data = response.read()
                image = Image.open(BytesIO(image_data))
                images.append(image)
        except Exception as e:
            print(f"Failed to download image from {url}: {str(e)}")
    return images


def convert_images_to_pdf(images: List[Image.Image], output_path: str) -> None:
    """Converts a list of in-memory images to PDF format and writes the resulting PDF file to disk."""
    print("Converting images to PDF...")
    pdf_writer = PdfWriter()
    for image in tqdm(images, desc="Converting to PDF"):
        with BytesIO() as image_stream:
            image.save(image_stream, format="PDF")
            image_stream.seek(0)
            pdf_reader = PdfReader(image_stream)
            pdf_writer.add_page(pdf_reader.pages[0])

    with open(output_path, "wb") as output_file:
        pdf_writer.write(output_file)
    print(f"PDF successfully written to: {output_path}")


def main():
    parser = ArgumentParser("issuu-pdf-dl", "Download Issuu documents as PDF.")
    parser.add_argument(
        "document_url", help="URL of the document to download", type=str
    )
    parser.add_argument("--output", "-o", help="output file path", type=str)
    parser.add_argument(
        "--save-images", help="save downloaded images", action="store_true"
    )
    args = parser.parse_args()

    url_parts = args.document_url.split("/")
    user = url_parts[3]
    title = url_parts[5]
    print(f"Downloading document '{title}' by '{user}'.")

    json_url = f"https://reader3.isu.pub/{user}/{title}/reader3_4.json"
    request = urllib.request.Request(json_url, headers={"Accept-Encoding": "gzip"})
    response = urllib.request.urlopen(request)
    if response.info().get("Content-Encoding") == "gzip":
        data = gzip.decompress(response.read())
    else:
        data = response.read()
    json_dict = json.loads(data.decode())

    pages_urls = [
        "https://" + page["imageUri"] for page in json_dict["document"]["pages"]
    ]

    downloaded_images = retrieve_images_from_urls(pages_urls)
    # Save images as JPG
    if args.save_images:
        download_dir = f"./{user}_{title}-images"
        os.makedirs(download_dir, exist_ok=True)
        for index, image in enumerate(downloaded_images):
            image.save(f"./{download_dir}/image{index + 1:03d}.jpg")

    output_path = args.output if args.output else f"./{user}-{title}.pdf"
    convert_images_to_pdf(downloaded_images, output_path)


if __name__ == "__main__":
    main()
