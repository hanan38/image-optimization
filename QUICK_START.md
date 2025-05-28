# Quick Start Guide

## 🚀 First Time Setup

```bash
# 1. Run setup (automatically installs dependencies)
python setup.py

# 2. Configure AWS credentials in upload_files.py (lines 18-21)
# Edit: AWS_ACCESS_KEY, AWS_SECRET_KEY, S3_BUCKET, CLOUDFRONT_DOMAIN

# 3. (Optional) Add AltText.ai API key to .env file for alt text generation
# ALTTEXT_AI_API_KEY=your_api_key_here
```

## 📋 Common Operations

### Process Images from CSV (Most Common)

```bash
# 1. Add URLs to images_to_download_and_upload.csv
# 2. Run the batch processor
./process_csv.sh
# 3. Choose options including alt text generation 🆕
# 4. Check results in images_mapping.csv
```

### Upload Local Files

```bash
# Put files in images_to_upload/ directory
python upload_files.py

# With alt text generation
export GENERATE_ALT_TEXT=1
python upload_files.py
```

### Start API Server

```bash
export FLASK_RUN=1
python upload_files.py
# Server runs on http://localhost:5000
```

## 🤖 Alt Text Features 🆕

```bash
# Test AltText.ai connection
python alttext_ai.py

# Generate alt text for single image
python alttext_ai.py https://example.com/image.jpg "keywords,here"

# Process CSV with alt text
./process_csv.sh
# Choose "y" when prompted for alt text generation
```

## 🔧 Troubleshooting Commands

```bash
# Check S3 bucket and permissions
python check_s3_objects.py

# Test AltText.ai connection
python setup.py

# Rebuild URL mappings
python regenerate_urls.py

# Test a CloudFront URL
curl -I https://your-domain.cloudfront.net/image_timestamp.webp
```

## ⚙️ Quick Configuration

| Setting | Recommended | Description |
|---------|-------------|-------------|
| Max Width | `600` | Good for web display |
| Quality | `82` | Balance of quality/size |
| Smart Format | `true` | Auto-optimize format |
| Alt Text | `true` | Generate descriptions 🆕 |
| Keywords | `"product,business"` | SEO optimization 🆕 |

## 📁 Key Files

- `images_to_download_and_upload.csv` - **INPUT**: Your image URLs
- `images_mapping.csv` - **OUTPUT**: URL mappings with alt text 🆕
- `local_files_alt_text.csv` - **OUTPUT**: Local file alt text 🆕
- `uploaded_files.json` - **STATE**: Tracks uploads
- `.env` - **CONFIG**: API keys and settings 🆕
- `process_csv.sh` - **SCRIPT**: Main processor

## 🎯 Pro Tips

1. **Test with a few images first** - Add 2-3 URLs to CSV and test
2. **Check CloudFront URLs** - Verify they return HTTP 200
3. **Use timestamps** - Ensures unique URLs and cache busting
4. **Monitor file sizes** - Smart format can reduce sizes by 80%+
5. **Generate alt text** - Improves SEO and accessibility 🆕
6. **Use keywords** - Include relevant terms for better SEO 🆕
7. **Backup your mappings** - Keep copies of `images_mapping.csv` 