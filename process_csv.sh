#!/bin/bash

# CloudFront Image Upload Utility - Interactive CSV Processor
# This script provides an interactive interface for processing images from CSV files

echo "🚀 CloudFront Image Upload Utility - CSV Processor"
echo "=================================================="

# Check if input file exists
INPUT_FILE="data/input/images_to_download_and_upload.csv"
if [ ! -f "$INPUT_FILE" ]; then
    echo "❌ Input file not found: $INPUT_FILE"
    echo ""
    echo "📋 Please create the input file with your image URLs:"
    echo "   mkdir -p data/input"
    echo "   echo 'URL' > $INPUT_FILE"
    echo "   echo 'https://example.com/your-image.jpg' >> $INPUT_FILE"
    echo ""
    echo "📄 Example files are available in data/examples/"
    exit 1
fi

echo "📄 Input file: $INPUT_FILE"
echo "📊 Output files:"
echo "   - data/output/images_mapping.csv"
echo "   - data/output/uploaded_files.json"
echo "   - data/output/local_files_alt_text.csv (if alt text is generated)"
echo ""

# Count URLs in input file
URL_COUNT=$(tail -n +2 "$INPUT_FILE" | grep -v '^#' | grep -v '^$' | wc -l | tr -d ' ')
echo "🔍 Found $URL_COUNT image URLs to process"
echo ""

# Prompt for max width
echo -n "Enter max width (leave empty for no resizing): "
read max_width

# Prompt for quality
echo -n "Enter quality (1-100, leave empty for default 82): "
read quality

# Prompt for smart format
echo -n "Use smart format conversion to optimize file size? (y/n, leave empty for yes): "
read smart_format

# Prompt for alt text generation
echo -n "Generate alt text for images using AltText.ai? (y/n, leave empty for no): "
read generate_alt_text

# Prompt for alt text keywords if alt text generation is enabled
alt_text_keywords=""
if [[ "$generate_alt_text" =~ ^[Yy] ]]; then
    echo -n "Enter keywords for SEO optimization (optional, leave empty for none): "
    read alt_text_keywords
fi

# Prompt for verbose mode
echo -n "Enable verbose output for debugging? (y/n, leave empty for no): "
read verbose_mode

# Set environment variables
export PROCESS_CSV=1

# Set max width if provided
if [ -n "$max_width" ]; then
    export MAX_WIDTH=$max_width
    echo "Max width set to: $max_width"
else
    echo "No max width set, images will not be resized"
fi

# Set quality if provided
if [ -n "$quality" ]; then
    export QUALITY=$quality
    echo "Quality set to: $quality"
else
    export QUALITY=82
    echo "Quality set to default: 82"
fi

# Set smart format option
if [ -z "$smart_format" ] || [[ "$smart_format" =~ ^[Yy] ]]; then
    export SMART_FORMAT=1
    echo "Smart format conversion enabled"
else
    export SMART_FORMAT=0
    echo "Smart format conversion disabled"
fi

# Set alt text generation option
if [[ "$generate_alt_text" =~ ^[Yy] ]]; then
    export GENERATE_ALT_TEXT=1
    echo "Alt text generation enabled"
    
    if [ -n "$alt_text_keywords" ]; then
        export ALT_TEXT_KEYWORDS="$alt_text_keywords"
        echo "Alt text keywords: $alt_text_keywords"
    else
        echo "No specific keywords set for alt text"
    fi
else
    export GENERATE_ALT_TEXT=0
    echo "Alt text generation disabled"
fi

# Set verbose mode
if [[ "$verbose_mode" =~ ^[Yy] ]]; then
    export VERBOSE=1
    echo "Verbose output enabled"
else
    export VERBOSE=0
    echo "Verbose output disabled"
fi

# Run the Python script
python upload_files.py

echo "CSV processing complete. Check data/output/images_mapping.csv for results."

# Show alt text information if it was enabled
if [[ "$generate_alt_text" =~ ^[Yy] ]]; then
    echo ""
    echo "📄 Alt text has been generated and included in the output CSV."
    echo "   The 'alt_text' column contains AI-generated descriptions for accessibility and SEO."
fi 