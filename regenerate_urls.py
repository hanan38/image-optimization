#!/usr/bin/env python3
"""
CloudFront URL Regeneration Utility

This utility rebuilds the images_mapping.csv file from the uploaded_files.json data.
It's useful when you need to regenerate the mapping file or when CloudFront URLs have changed.

Input files:
- data/output/uploaded_files.json (contains current S3 objects)
- data/input/images_to_download_and_upload.csv (contains original source URLs)

Output files:
- data/output/images_mapping.csv (rebuilt mapping file)

Usage:
    python regenerate_urls.py
"""

import csv
import json
import os

# File paths
JSON_FILE = "data/output/uploaded_files.json"
CSV_INPUT_FILE = "data/input/images_to_download_and_upload.csv"
CSV_OUTPUT_FILE = "data/output/images_mapping.csv"


def regenerate_mapping():
    """Regenerate the images_mapping.csv with correct CloudFront URLs from uploaded_files.json"""

    # Load uploaded files
    with open(JSON_FILE, "r") as f:
        uploaded_files = json.load(f)

    # Load original CSV to get the source URLs
    source_urls = []
    with open(CSV_INPUT_FILE, "r") as f:
        reader = csv.DictReader(f)
        for row in reader:
            source_urls.append(row["URL"])

    # Create mapping
    url_mapping = []
    for source_url in source_urls:
        # Extract filename from URL
        import urllib.parse

        parsed_url = urllib.parse.urlparse(source_url)
        file_name = os.path.basename(parsed_url.path)

        # Convert to likely webp name (removing extension and adding .webp)
        webp_name = os.path.splitext(file_name)[0] + ".webp"

        # Look for this file in uploaded_files
        file_info = None
        for key, info in uploaded_files.items():
            # Check if the key matches the webp name (ignoring case)
            if key.lower() == webp_name.lower():
                file_info = info
                break
            # Also check if the original filename matches
            elif key.lower() == file_name.lower():
                file_info = info
                break

        if file_info:
            url_mapping.append(
                {
                    "source_url": source_url,
                    "cloudfront_url": file_info["cloudfront_url"],
                    "max_width": 600,
                    "quality": 82,
                    "smart_format": True,
                }
            )
            print(f"✓ Mapped: {source_url} -> {file_info['cloudfront_url']}")
        else:
            print(f"✗ Not found: {source_url} (looking for {webp_name})")

    # Write new mapping to CSV
    with open(CSV_OUTPUT_FILE, "w", newline="") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=[
                "source_url",
                "cloudfront_url",
                "max_width",
                "quality",
                "smart_format",
            ],
        )
        writer.writeheader()
        for mapping in url_mapping:
            writer.writerow(mapping)

    print(f"\nRegenerated {len(url_mapping)} mappings in {CSV_OUTPUT_FILE}")
    return url_mapping


if __name__ == "__main__":
    print("Regenerating CloudFront URL mappings...")
    print("=" * 50)
    regenerate_mapping()
