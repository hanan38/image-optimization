# CloudFront Image Upload Utility

A comprehensive tool for downloading, optimizing, and uploading images to AWS S3 with CloudFront distribution. Features automatic image optimization, format conversion, unique URL generation, and **AI-powered alt text generation** for accessibility and SEO.

## 🚀 Features

- **Batch Image Processing**: Download images from URLs and upload to S3/CloudFront
- **Image Optimization**: Automatic resizing, quality adjustment, and format conversion
- **Smart Format Selection**: Automatically chooses the best format (JPEG, PNG, WebP) for optimal file size
- **Unique URLs**: Adds timestamps to prevent filename conflicts and ensure cache busting
- **AI Alt Text Generation**: Generate descriptive alt text using AltText.ai API 🆕
- **REST API**: HTTP endpoints for programmatic access
- **Comprehensive Logging**: Detailed progress tracking and error reporting

## 📋 Prerequisites

- Python 3.7+
- AWS S3 bucket with CloudFront distribution
- AWS credentials with S3 upload permissions
- **AltText.ai API key** (optional, for alt text generation)

## 🚀 Quick Start

### First Time Setup

```bash
# 1. Run setup (automatically installs dependencies)
python setup.py

# 2. Configure AWS credentials in upload_files.py (lines 18-21)
# Edit: AWS_ACCESS_KEY, AWS_SECRET_KEY, S3_BUCKET, CLOUDFRONT_DOMAIN

# 3. (Optional) Add AltText.ai API key to .env file for alt text generation
# ALTTEXT_AI_API_KEY=your_api_key_here
```

### Most Common Operation: Process Images from CSV

```bash
# 1. Add URLs to images_to_download_and_upload.csv
# 2. Run the batch processor
./process_csv.sh
# 3. Choose options including alt text generation 🆕
# 4. Check results in images_mapping.csv
```

## 🛠 Installation

1. **Install Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

2. **Run Setup Script**:
   ```bash
   python setup.py
   ```
   This will:
   - Check dependencies and install missing ones
   - Create required directories and files
   - Create environment file template for API keys
   - Test connections

3. **Configure Credentials**: 
   - **AWS**: Update AWS credentials in `upload_files.py` (lines 18-21)
   - **AltText.ai**: Add your API key to `.env` file:
     ```
     ALTTEXT_AI_API_KEY=your_api_key_here
     ALTTEXT_AI_KEYWORDS=optional,seo,keywords
     ```

## 📚 Usage Methods

### Method 1: Batch Processing from CSV (Recommended)

1. **Prepare Input File**: Create `images_to_download_and_upload.csv`:
   ```csv
   URL
   https://example.com/image1.jpg
   https://example.com/image2.png
   https://example.com/image3.jpeg
   ```

2. **Run the Processing Script**:
   ```bash
   ./process_csv.sh
   ```

3. **Configure Options**: You'll be prompted to set:
   - **Max width**: Maximum pixel width for resizing (empty = no resizing)
   - **Quality**: JPEG/WebP quality 1-100 (default: 82)
   - **Smart format**: Auto-select best format (default: yes)
   - **Generate alt text**: Use AltText.ai for descriptions (default: no) 🆕
   - **Alt text keywords**: SEO keywords for optimization (optional) 🆕
   - **Verbose mode**: Enable detailed logging (default: no)

4. **View Results**: Check `images_mapping.csv` for the original URL to CloudFront URL mappings with alt text.

### Method 2: Upload Local Files

```bash
# Put files in images_to_upload/ directory
python upload_files.py

# With alt text generation
export GENERATE_ALT_TEXT=1
export ALT_TEXT_KEYWORDS="product,clothing,fashion"
python upload_files.py
```

### Method 3: REST API

1. **Start the Server**:
   ```bash
   export FLASK_RUN=1
   python upload_files.py
   # Server runs on http://localhost:5000
   ```

2. **Upload with Alt Text**:
   ```bash
   curl -X POST -F "file=@/path/to/image.jpg" \
        -F "max_width=600" \
        -F "quality=82" \
        -F "smart_format=true" \
        -F "generate_alt_text=true" \
        -F "alt_text_keywords=product,ecommerce" \
        http://localhost:5000/upload
   ```

3. **Process CSV with Alt Text**:
   ```bash
   curl -X GET "http://localhost:5000/process-csv?max_width=600&quality=82&smart_format=true&generate_alt_text=true&alt_text_keywords=business,marketing"
   ```

## 🤖 Alt Text Generation (AltText.ai Integration)

### Overview
The system includes **optional alt text generation** using the AltText.ai API. This feature automatically generates descriptive alt text for images during processing, enhancing accessibility and SEO.

### Features
- **AI-Powered**: Uses AltText.ai's advanced computer vision
- **SEO Optimized**: Include custom keywords for better search ranking
- **Accessibility**: Improve website accessibility compliance
- **Batch Processing**: Generate alt text for hundreds of images at once
- **CSV Export**: Alt text included in output mapping files
- **Optional Integration**: Can be enabled/disabled as needed

### Setup
1. **Get API Key**: Sign up at [AltText.ai](https://alttext.ai) 
2. **Configure**: Add key to `.env` file:
   ```bash
   # AltText.ai API Configuration
   ALTTEXT_AI_API_KEY=your_api_key_here
   
   # Optional: Custom keywords for SEO optimization
   ALTTEXT_AI_KEYWORDS=car shipping, vehicle transport
   
   # Optional: Webhook URL for asynchronous processing
   ALTTEXT_AI_WEBHOOK_URL=
   ```
3. **Test**: Run `python setup.py` to verify connection

### Usage Examples

**Interactive Mode (Recommended):**
```bash
./process_csv.sh
# Follow prompts to enable alt text generation
```

**Automated Mode:**
```bash
# Enable alt text generation
export PROCESS_CSV=1
export GENERATE_ALT_TEXT=true
export ALT_TEXT_KEYWORDS="car shipping, vehicle transport, RV transport"
export MAX_WIDTH=800
export QUALITY=85
export SMART_FORMAT=true

python upload_files.py
```

**API Testing:**
```bash
# Test API connection
python -c "from alttext_ai import test_alttext_ai_connection; test_alttext_ai_connection()"

# Test alt text generation
python -c "from alttext_ai import generate_alt_text; print(generate_alt_text('https://example.com/image.jpg'))"

# Generate alt text for single image with keywords
python alttext_ai.py https://example.com/image.jpg "keywords,here"
```

### Example Output
When alt text generation is enabled, the output CSV includes an additional `alt_text` column:

```csv
source_url,cloudfront_url,max_width,quality,smart_format,alt_text
https://example.com/image.jpg,https://cdn.example.com/optimized.webp,800,85,True,"A blue golf cart parked on a grassy slope next to a golf course path, surrounded by trees and greenery."
```

### Real Examples from Test Run

| Image Type | Generated Alt Text |
|------------|-------------------|
| Golf Cart | "A blue golf cart is parked on a grassy slope next to a golf course path, surrounded by trees and greenery." |
| Car Transport | "A car carrier truck transports multiple white sedans stacked in two rows on an open trailer, parked on a city street beside a large building." |
| RV Transport | "Shipping an RV with a red truck." |
| Container Shipping | "A Toyota SUV is loaded inside a red shipping container with the container door open, showing weight and capacity specifications." |

## ⚙️ Configuration Options

| Parameter | Description | Default | Example |
|-----------|-------------|---------|---------|
| `max_width` | Maximum image width in pixels | None (no resizing) | `600`, `1200` |
| `quality` | JPEG/WebP quality (1-100) | `82` | `75`, `90` |
| `smart_format` | Auto-select best format | `true` | `true`, `false` |
| `add_timestamp` | Add timestamp to filename | `true` | `true`, `false` |
| `generate_alt_text` | Generate AI alt text | `false` | `true`, `false` 🆕 |
| `alt_text_keywords` | SEO keywords for alt text | None | `"product,clothing"` 🆕 |

### Quick Configuration Recommendations

| Setting | Recommended | Description |
|---------|-------------|-------------|
| Max Width | `600` | Good for web display |
| Quality | `82` | Balance of quality/size |
| Smart Format | `true` | Auto-optimize format |
| Alt Text | `true` | Generate descriptions 🆕 |
| Keywords | `"product,business"` | SEO optimization 🆕 |

### Environment Variables
- `ALTTEXT_AI_API_KEY` - Your AltText.ai API key (required)
- `ALTTEXT_AI_KEYWORDS` - Default keywords for SEO (optional)
- `ALTTEXT_AI_WEBHOOK_URL` - Webhook for async processing (optional)
- `GENERATE_ALT_TEXT` - Enable/disable alt text generation (true/false)
- `ALT_TEXT_KEYWORDS` - Keywords for current processing session

## 🖼 Image Optimization Details

### Format Selection Algorithm

The tool tests each image in multiple formats and selects the smallest:

1. **JPEG**: Best for photographs and complex images
2. **PNG**: Best for images with transparency or sharp edges  
3. **WebP**: Modern format with superior compression for most images
4. **GIF**: Preserved as-is to maintain animation

### Optimization Process

1. **Download**: Fetches image from source URL with proper headers
2. **Resize**: Reduces dimensions if width exceeds `max_width`
3. **Format Test**: Converts to JPEG, PNG, and WebP to compare file sizes
4. **Quality Adjust**: Applies compression based on `quality` setting
5. **Alt Text**: Generates descriptive text using AI (if enabled) 🆕
6. **Upload**: Uploads optimized image to S3 with unique timestamp
7. **URL Generation**: Creates CloudFront URL with timestamp

### Example Optimization Results

```
Original: 1600x1200 JPEG (291KB)
Optimized: 600x450 WebP (29.5KB) - 90% size reduction!
Alt Text: "Modern office workspace with laptop and coffee cup on wooden desk"
```

## 📁 File Structure

```
image-optimization/
├── upload_files.py              # Main application
├── alttext_ai.py               # AltText.ai API integration 🆕
├── process_csv.sh               # Batch processing script
├── setup.py                     # Setup & dependency checker
├── check_s3_objects.py          # S3 debugging utility
├── regenerate_urls.py           # URL mapping regeneration
├── requirements.txt             # Python dependencies
├── .env                        # Environment variables (API keys) 🆕
├── env.example                 # Environment template 🆕
├── README.md                    # Complete documentation
├── .gitignore                  # Git exclusions
├── images_to_download_and_upload.csv  # INPUT: Your image URLs
├── images_mapping.csv           # OUTPUT: URL mappings with alt text 🆕
├── local_files_alt_text.csv    # OUTPUT: Local file alt text 🆕
├── uploaded_files.json          # STATE: Tracks uploads
└── images_to_upload/            # Local files directory
```

### Key Files

- `images_to_download_and_upload.csv` - **INPUT**: Your image URLs
- `images_mapping.csv` - **OUTPUT**: URL mappings with alt text 🆕
- `local_files_alt_text.csv` - **OUTPUT**: Local file alt text 🆕
- `uploaded_files.json` - **STATE**: Tracks uploads
- `.env` - **CONFIG**: API keys and settings 🆕
- `process_csv.sh` - **SCRIPT**: Main processor

## 📊 Output Files

### `images_mapping.csv` (Enhanced)
Maps source URLs to optimized CloudFront URLs with alt text:
```csv
source_url,cloudfront_url,max_width,quality,smart_format,alt_text
https://example.com/image.jpg,https://cdn.example.com/image_1748441097.webp,600,82,True,"Professional headshot of smiling woman in business attire"
```

### `local_files_alt_text.csv` (New)
Alt text for locally uploaded files:
```csv
filename,cloudfront_url,alt_text
product_image.webp,https://cdn.example.com/product_image_1748441097.webp,"Red running shoes with white sole on gray background"
```

## 🔧 Utility Scripts

### AltText.ai Testing Tool 🆕
```bash
python alttext_ai.py https://example.com/image.jpg "product,shoes,running"
```

### S3 Debugging Tool
```bash
python check_s3_objects.py
```

### URL Regeneration Tool
```bash
python regenerate_urls.py
```

## 🔧 Troubleshooting

### Common Issues

**"AltText.ai API connection failed"**
- ✅ **Solution**: Check your API key in `.env` file
- 🔍 **Test**: Run `python setup.py` to verify connection

**"Alt text generation disabled"**
- ✅ **Solution**: Install python-dotenv: `pip install python-dotenv`
- 🔍 **Check**: Verify ALTTEXT_AI_API_KEY is set in `.env` file

**"Access Denied" errors**
- ✅ **Solution**: The script automatically handles this by uploading without ACLs
- 🔍 **Check**: Verify your CloudFront distribution is properly configured

**"File already processed, skipping"**
- ✅ **Solution**: The script checks existing mappings to avoid duplicates
- 🔍 **Force reprocess**: Delete the corresponding entry from `images_mapping.csv`

### Debug Commands

```bash
# Test AltText.ai connection
python alttext_ai.py

# Test S3 bucket access
python check_s3_objects.py

# Test specific CloudFront URL
curl -I https://your-cloudfront-domain.net/image_timestamp.webp

# Check environment variables
python -c "from dotenv import load_dotenv; load_dotenv(); import os; print('API Key configured:', bool(os.getenv('ALTTEXT_AI_API_KEY')))"

# Check S3 bucket and permissions
python check_s3_objects.py

# Rebuild URL mappings
python regenerate_urls.py
```

## 🎯 Pro Tips

1. **Test with a few images first** - Add 2-3 URLs to CSV and test
2. **Check CloudFront URLs** - Verify they return HTTP 200
3. **Use timestamps** - Ensures unique URLs and cache busting
4. **Monitor file sizes** - Smart format can reduce sizes by 80%+
5. **Generate alt text** - Improves SEO and accessibility 🆕
6. **Use keywords** - Include relevant terms for better SEO 🆕
7. **Backup your mappings** - Keep copies of `images_mapping.csv`
8. **Batch Processing**: Process multiple images in one session
9. **Optimal Quality**: Use quality 80-85 for good balance
10. **Smart Resizing**: Set max_width to your typical display size

## 🔒 Security Notes

- AWS credentials are currently hardcoded in the script
- **AltText.ai API key is stored in `.env` file** (gitignored for security)
- For production use, consider using:
  - Environment variables
  - AWS IAM roles
  - AWS credentials file
  - AWS Secrets Manager

## 📈 Performance & Benefits

### Performance Features
- **Concurrent processing** - Images processed in parallel
- **Smart caching** - Avoids re-processing existing images
- **Efficient API usage** - Optimized request patterns
- **Progress tracking** - Real-time status updates
- **API Rate Limits**: AltText.ai has generous rate limits for batch processing

### Alt Text Benefits

#### 🎯 Accessibility
- **Screen reader support** with descriptive alt text
- **WCAG compliance** for web accessibility standards
- **Inclusive design** for users with visual impairments

#### 🚀 SEO Optimization
- **Image search optimization** with descriptive text
- **Keyword integration** for targeted SEO
- **Content enrichment** for better search rankings

#### ⚡ Automation
- **Batch processing** for large image sets
- **Consistent quality** across all images
- **Time savings** compared to manual alt text creation

## 🔧 Error Handling

The system includes comprehensive error handling:

- **API connectivity issues** - Graceful fallback with clear messages
- **Invalid API keys** - Clear authentication error messages
- **Network timeouts** - Retry mechanisms with exponential backoff
- **Image processing errors** - Continue processing other images
- **Missing dependencies** - Clear installation instructions

## 🤝 Contributing

To extend the utility:

1. **Add new optimization features** in `optimize_image()` function
2. **Enhance alt text features** in `alttext_ai.py` module
3. **Add new API endpoints** in the Flask app section
4. **Improve error handling** in download/upload functions

## 🚀 Future Enhancements

Potential improvements for future versions:

- **Batch API requests** for improved efficiency
- **Custom prompts** for specific alt text styles
- **Multi-language support** for international content
- **Alt text validation** and quality scoring
- **Integration with CMS systems** for direct publishing

## 📄 License

This utility is part of the CS Growth Hacks project. Please ensure you have proper AWS permissions and comply with AWS usage policies. AltText.ai usage subject to their terms of service.

---

**Note**: Alt text generation is optional and can be disabled if not needed. The system works perfectly without it, maintaining backward compatibility with existing workflows. 