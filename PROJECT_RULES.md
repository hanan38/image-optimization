# Project Rules & Guidelines

**Status**: Living Document  
**Version History**: See [CHANGELOG.md](CHANGELOG.md)  

This document serves as a comprehensive guide for AI models and developers working with the CloudFront Image Upload Utility repository. It outlines project structure, coding standards, conventions, and best practices.

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Repository Structure](#repository-structure)
- [Core Components](#core-components)
- [Coding Standards](#coding-standards)
- [File Naming Conventions](#file-naming-conventions)
- [Environment & Configuration](#environment--configuration)
- [API Integration Guidelines](#api-integration-guidelines)
- [Error Handling Standards](#error-handling-standards)
- [Documentation Standards](#documentation-standards)
- [Testing Guidelines](#testing-guidelines)
- [Security Guidelines](#security-guidelines)
- [Performance Guidelines](#performance-guidelines)
- [Deployment Guidelines](#deployment-guidelines)
- [Change Management](#change-management)

## 🎯 Project Overview

### Purpose
CloudFront Image Upload Utility is a comprehensive tool for downloading, optimizing, and uploading images to AWS S3 with CloudFront distribution, featuring AI-powered alt text generation for accessibility and SEO.

### Core Functionality
1. **Image Processing**: Download, optimize, and upload images
2. **Format Optimization**: Smart format selection (JPEG, PNG, WebP)
3. **Alt Text Generation**: AI-powered descriptions using AltText.ai
4. **Batch Processing**: CSV-based bulk operations
5. **REST API**: HTTP endpoints for programmatic access

### Technology Stack
- **Language**: Python 3.9+ (Recommended: Python 3.13)
- **Cloud**: AWS S3 + CloudFront
- **AI Service**: AltText.ai API
- **Image Processing**: Pillow (PIL)
- **Web Framework**: Flask
- **Environment**: python-dotenv

### Supported Python Versions
- **Python 3.9**: Minimum supported version
- **Python 3.10**: Fully supported
- **Python 3.11**: Fully supported
- **Python 3.12**: Fully supported
- **Python 3.13**: Recommended (latest stable)

## 📁 Repository Structure

```
image-optimization/
├── Core Application Files
│   ├── upload_files.py              # Main application & Flask API
│   ├── alttext_ai.py               # AltText.ai API integration
│   ├── setup.py                     # Setup & dependency checker
│   └── requirements.txt             # Python dependencies
├── Processing Scripts
│   ├── process_csv.sh               # Interactive batch processor
│   ├── check_s3_objects.py          # S3 debugging utility
│   └── regenerate_urls.py           # URL mapping regeneration
├── Configuration
│   ├── .env                        # Environment variables (gitignored)
│   ├── env.example                 # Environment template
│   └── .gitignore                  # Git exclusions
├── Data Files
│   ├── data/
│   │   ├── input/                  # Input CSV files
│   │   │   └── images_to_download_and_upload.csv
│   │   ├── output/                 # Generated output files
│   │   │   ├── images_mapping.csv
│   │   │   ├── uploaded_files.json
│   │   │   └── local_files_alt_text.csv
│   │   ├── examples/               # Example files for reference
│   │   └── local_images/           # Downloaded/local image files
└── Documentation
    ├── README.md                    # Complete documentation
    ├── CHANGELOG.md                 # Version history and releases
    └── PROJECT_RULES.md             # This document
```

### File Categories

#### **Core Application Files**
- `upload_files.py`: Main application with all core functionality
- `alttext_ai.py`: Dedicated AltText.ai API client
- `setup.py`: Environment setup and dependency management

#### **Processing Scripts**
- `process_csv.sh`: User-friendly batch processing interface
- Utility scripts for debugging and maintenance

#### **Configuration Files**
- `.env`: Sensitive configuration (API keys, credentials)
- `env.example`: Template for environment setup

#### **Data Files**
- Input files (CSV with URLs)
- Output files (mappings, alt text)
- State files (tracking uploads)

## 🔧 Core Components

### 1. Main Application (`upload_files.py`)

**Primary Functions:**
- `upload_files()`: Local file upload with optimization
- `download_and_upload_from_csv()`: Batch processing from CSV
- `optimize_image()`: Image optimization and format conversion
- `upload_file_to_s3()`: S3 upload functionality

**Flask API Endpoints:**
- `POST /upload`: Single file upload
- `GET /files`: List uploaded files
- `GET /process-csv`: Batch CSV processing

**Key Features:**
- Environment variable configuration
- Optional alt text integration
- Comprehensive error handling
- Progress tracking and logging

### 2. AltText.ai Integration (`alttext_ai.py`)

**Classes:**
- `AltTextAI`: Main API client class

**Key Methods:**
- `generate_alt_text()`: Generate alt text for images
- `test_connection()`: Verify API connectivity
- `_poll_for_result()`: Handle asynchronous processing

**Features:**
- Synchronous and asynchronous processing
- Keyword integration for SEO
- Webhook support
- Robust error handling

### 3. Setup & Utilities (`setup.py`)

**Functions:**
- Dependency checking and installation
- Environment file creation
- Connection testing
- Directory structure validation

## 📝 Coding Standards

### Python Version Compatibility

#### **Target Versions**
- **Primary**: Python 3.13 (recommended for development)
- **Supported**: Python 3.9, 3.10, 3.11, 3.12, 3.13
- **Testing**: All supported versions in CI/CD

#### **Version-Specific Guidelines**
```python
# Use features available in Python 3.9+
from typing import Optional, Union, List, Dict, Tuple
from pathlib import Path

# Avoid features from Python 3.14+ (not yet stable)
# Use type hints compatible with Python 3.9+
def process_image(path: str | Path) -> bool:  # ❌ Union syntax (3.10+)
def process_image(path: Union[str, Path]) -> bool:  # ✅ Compatible with 3.9+
```

### Development Environment Setup

#### **Virtual Environment (Recommended)**
```python
# Create virtual environment with Python 3.13
python3.13 -m venv venv

# Activate virtual environment
source venv/bin/activate  # Linux/macOS
venv\Scripts\activate     # Windows

# Verify Python version
python --version  # Should show Python 3.13.x
```

#### **Development Dependencies**
```bash
# Core dependencies
pip install -r requirements.txt

# Development tools
pip install flake8 black isort mypy bandit safety
```

### Python Code Style

#### **Import Organization**
```python
# Standard library imports
import os
import json
import time
from pathlib import Path
from typing import Optional, Union, List, Dict, Tuple

# Third-party imports
import boto3
import requests
from PIL import Image

# Local imports
from alttext_ai import generate_alt_text
```

#### **Function Documentation**
```python
def optimize_image(image_path: str, max_width: Optional[int] = None, 
                  quality: int = 82, smart_format: bool = True) -> Tuple[bool, str]:
    """
    Optimize an image by resizing, adjusting quality, and choosing the best format
    
    Args:
        image_path (str): Path to the image file
        max_width (int, optional): Maximum width for resizing
        quality (int): JPEG/WebP quality (1-100)
        smart_format (bool): Enable smart format selection
        
    Returns:
        tuple: (success: bool, optimized_path: str)
        
    Raises:
        FileNotFoundError: If image file doesn't exist
        ValueError: If quality is not in valid range
    """
```

#### **Error Handling Pattern**
```python
try:
    # Main operation
    result = perform_operation()
    print(f"✅ Operation successful: {result}")
    return True, result
except SpecificException as e:
    print(f"❌ Specific error: {e}")
    return False, None
except Exception as e:
    print(f"❌ Unexpected error: {e}")
    return False, None
```

#### **Logging Standards**
- Use emoji prefixes for visual clarity: ✅ ❌ 🔍 ⏳ 📄
- Include context in error messages
- Provide actionable feedback to users
- Use consistent formatting

### Configuration Management

#### **Environment Variables**
```python
# Required AWS Configuration
AWS_ACCESS_KEY = os.getenv('AWS_ACCESS_KEY')
AWS_SECRET_KEY = os.getenv('AWS_SECRET_KEY')
S3_BUCKET = os.getenv('S3_BUCKET')
CLOUDFRONT_DOMAIN = os.getenv('CLOUDFRONT_DOMAIN')

# Optional AltText.ai Configuration
ALTTEXT_AI_API_KEY = os.getenv('ALTTEXT_AI_API_KEY')
ALTTEXT_AI_KEYWORDS = os.getenv('ALTTEXT_AI_KEYWORDS', '')
```

#### **Default Values**
```python
# Use constants for default values
DEFAULT_QUALITY = 82
DEFAULT_MAX_WIDTH = None
SMART_FORMAT = True
```

## 📋 File Naming Conventions

### **Python Files**
- Use snake_case: `upload_files.py`, `alttext_ai.py`
- Descriptive names indicating purpose
- Avoid abbreviations unless widely understood

### **Data Files**
- CSV files: descriptive_purpose.csv
- JSON files: state_tracking.json
- Use underscores for multi-word names

### **Generated Files**
- Include timestamps: `image_1748441097.webp`
- Lowercase filenames for web compatibility
- Preserve original extensions when possible

### **Directory Structure**
- Use lowercase with underscores: `images_to_upload/`
- Descriptive directory names
- Separate input/output/state directories

## 🔐 Environment & Configuration

### **Required Environment Variables**
```bash
# AWS Configuration (Required)
AWS_ACCESS_KEY=your_aws_access_key
AWS_SECRET_KEY=your_aws_secret_key
S3_BUCKET=your_s3_bucket_name
CLOUDFRONT_DOMAIN=your_cloudfront_domain

# AltText.ai Configuration (Optional)
ALTTEXT_AI_API_KEY=your_alttext_ai_api_key
ALTTEXT_AI_KEYWORDS=default,keywords,for,seo
ALTTEXT_AI_WEBHOOK_URL=your_webhook_url
```

### **Configuration Hierarchy**
1. Environment variables (highest priority)
2. Command line arguments
3. Default values in code (lowest priority)

### **Security Requirements**
- Never commit `.env` files
- Use `.env.example` for templates
- Validate all environment variables on startup
- Provide clear error messages for missing config

## 🔌 API Integration Guidelines

### **AltText.ai Integration**

#### **Connection Testing**
```python
def test_connection(self) -> bool:
    """Test API connectivity without using external resources"""
    try:
        response = requests.get(
            f"{self.base_url}/jobs/test-connection-check",
            headers=self.headers,
            timeout=10
        )
        return response.status_code in [200, 202, 404]
    except Exception:
        return False
```

#### **Error Handling**
- Graceful degradation when API unavailable
- Clear user feedback about API status
- Retry mechanisms for transient failures
- Timeout handling for long-running requests

#### **Rate Limiting**
- Respect API rate limits
- Implement exponential backoff
- Batch requests when possible
- Monitor API usage

### **AWS S3 Integration**

#### **Upload Strategy**
- Use unique filenames with timestamps
- Handle ACL restrictions gracefully
- Implement retry logic for failed uploads
- Validate file uploads

#### **Error Handling**
```python
try:
    s3_client.upload_file(file_path, S3_BUCKET, file_name)
    return True, file_name
except ClientError as e:
    print(f"❌ S3 upload failed: {e}")
    return False, None
```

## ⚠️ Error Handling Standards

### **Error Categories**

#### **User Errors**
- Missing configuration
- Invalid file formats
- Network connectivity issues
- Provide clear, actionable messages

#### **System Errors**
- API failures
- File system issues
- Memory/resource constraints
- Log detailed information for debugging

#### **Graceful Degradation**
- Continue processing when possible
- Disable optional features if unavailable
- Provide fallback mechanisms
- Maintain data integrity

### **Error Message Format**
```python
# Good error messages
print("❌ AltText.ai API connection failed. Alt text generation will be disabled.")
print("✅ Solution: Check your API key in .env file")
print("🔍 Test: Run `python setup.py` to verify connection")

# Include context and solutions
print(f"❌ Failed to upload {filename}: {error_details}")
print("🔄 Retrying with alternative method...")
```

## 📚 Documentation Standards

### **Code Documentation**

#### **Function Docstrings**
- Use Google-style docstrings
- Include parameter types and descriptions
- Document return values
- Provide usage examples for complex functions

#### **Inline Comments**
- Explain complex logic
- Document business rules
- Clarify non-obvious code
- Keep comments up-to-date

### **README Structure**
- Quick start section first
- Comprehensive usage examples
- Troubleshooting section
- Configuration reference
- API documentation

### **Change Documentation**
- Update version numbers
- Document breaking changes
- Provide migration guides
- Update examples and screenshots

## 🧪 Testing Guidelines

### **Python Version Testing**

#### **Local Testing**
```bash
# Test with different Python versions (if available)
python3.9 upload_files.py
python3.10 upload_files.py
python3.11 upload_files.py
python3.12 upload_files.py
python3.13 upload_files.py
```

#### **CI/CD Testing**
- Automated testing on Python 3.9-3.13
- Matrix builds for all supported versions
- Version-specific compatibility checks

### **Manual Testing**

#### **Core Functionality Tests**
```bash
# Test AltText.ai connection
python -c "from alttext_ai import test_alttext_ai_connection; test_alttext_ai_connection()"

# Test image optimization
python upload_files.py

# Test CSV processing
./process_csv.sh
```

#### **API Testing**
```bash
# Test Flask API endpoints
curl -X POST -F "file=@test.jpg" http://localhost:5000/upload
curl -X GET http://localhost:5000/files
```

### **Integration Testing**
- Test with various image formats
- Verify S3 upload functionality
- Test CloudFront URL generation
- Validate alt text generation

### **Error Scenario Testing**
- Test with invalid API keys
- Test with network failures
- Test with corrupted images
- Test with missing dependencies

## 🔒 Security Guidelines

### **Credential Management**
- Store sensitive data in `.env` files
- Never commit credentials to version control
- Use environment variables in production
- Rotate API keys regularly

### **Input Validation**
- Validate all user inputs
- Sanitize file names
- Check file types and sizes
- Prevent path traversal attacks

### **API Security**
- Use HTTPS for all API calls
- Implement request timeouts
- Validate API responses
- Handle authentication errors gracefully

## ⚡ Performance Guidelines

### **Image Processing**
- Use efficient image libraries (Pillow)
- Implement smart format selection
- Optimize compression settings
- Process images in parallel when possible

### **API Usage**
- Batch API requests when possible
- Implement caching for repeated requests
- Use connection pooling
- Monitor API rate limits

### **File Operations**
- Use streaming for large files
- Implement progress tracking
- Clean up temporary files
- Optimize disk I/O operations

## 🚀 Deployment Guidelines

### **Environment Setup**
1. Install Python 3.9+ (recommended: 3.13): `python3.13 --version`
2. Create virtual environment: `python3.13 -m venv venv`
3. Activate virtual environment: `source venv/bin/activate`
4. Install dependencies: `pip install -r requirements.txt`
5. Run setup script: `python setup.py`
6. Configure environment variables
7. Test all integrations

### **Production Considerations**
- Use production-grade WSGI server for Flask API
- Implement proper logging
- Set up monitoring and alerting
- Configure backup strategies

### **Scaling Considerations**
- Implement queue-based processing for large batches
- Use distributed storage for temporary files
- Consider containerization for deployment
- Implement health checks

## 📝 Change Management

### **Version Control**
- Use semantic versioning (MAJOR.MINOR.PATCH)
- Tag releases in git
- Maintain changelog
- Document breaking changes

### **Code Review Process**
- Review all changes before merging
- Test functionality thoroughly
- Update documentation as needed
- Verify security implications

### **Release Process**
1. Update version numbers
2. Update documentation
3. Test all functionality
4. Create release notes
5. Tag release in git

## 🔄 Living Document Updates

### **When to Update This Document**
- Adding new features or components
- Changing coding standards or conventions
- Updating dependencies or integrations
- Modifying project structure
- Learning from production issues

### **Update Process**
1. Identify changes needed
2. Update relevant sections
3. Review with team if applicable
4. Document significant changes in [CHANGELOG.md](CHANGELOG.md)

### **Version History**
All version history and significant changes are tracked in [CHANGELOG.md](CHANGELOG.md). This document focuses on current standards and guidelines rather than historical changes.

---

**Note**: This document should be consulted before making any significant changes to the codebase. When in doubt, follow the patterns established in existing code and update this document to reflect any new conventions. 