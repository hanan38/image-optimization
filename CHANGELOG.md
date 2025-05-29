# Changelog

All notable changes to the CloudFront Image Upload Utility will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-05-28

### Added
- **AI Alt Text Generation**: Integration with AltText.ai API for automatic alt text generation
- **Interactive CSV Processing**: User-friendly script (`process_csv.sh`) with prompts
- **REST API**: Flask-based HTTP endpoints for programmatic access
- **Image Optimization**: Smart format selection (JPEG, PNG, WebP) with quality control
- **Batch Processing**: Process multiple images from CSV files
- **CloudFront Integration**: Automatic URL generation with timestamp-based cache busting
- **Environment Configuration**: Secure API key management with `.env` files
- **Comprehensive Logging**: Detailed progress tracking with emoji indicators
- **Error Handling**: Graceful degradation and retry mechanisms
- **Setup Automation**: Dependency checking and environment setup script

### Core Features
- Download images from URLs
- Optimize images (resize, compress, format conversion)
- Upload to AWS S3 with CloudFront distribution
- Generate AI-powered alt text for accessibility and SEO
- Export URL mappings and metadata to CSV
- Track upload status and prevent duplicates

### Files Added
- `upload_files.py` - Main application with all core functionality
- `alttext_ai.py` - AltText.ai API client and integration
- `setup.py` - Environment setup and dependency management
- `process_csv.sh` - Interactive batch processing script
- `check_s3_objects.py` - S3 debugging and verification utility
- `regenerate_urls.py` - URL mapping regeneration tool
- `requirements.txt` - Python dependencies
- `env.example` - Environment configuration template
- `.gitignore` - Git exclusions for security
- `README.md` - Comprehensive documentation

### API Endpoints
- `POST /upload` - Upload and optimize single files
- `GET /files` - List uploaded files
- `GET /process-csv` - Process images from CSV

### Output Files
- `images_mapping.csv` - URL mappings with alt text and metadata
- `local_files_alt_text.csv` - Alt text for local files
- `uploaded_files.json` - Upload tracking and state management

### Configuration Options
- Image quality control (1-100)
- Maximum width resizing
- Smart format selection
- Alt text generation with custom keywords
- Verbose logging mode

### Dependencies
- Python 3.9+ (originally 3.7+, updated for better compatibility)
- boto3 (AWS SDK)
- Pillow (PIL) for image processing
- Flask for REST API
- requests for HTTP operations
- python-dotenv for environment management

---

## Release Notes Format

### Types of Changes
- **Added** for new features
- **Changed** for changes in existing functionality
- **Deprecated** for soon-to-be removed features
- **Removed** for now removed features
- **Fixed** for any bug fixes
- **Security** for vulnerability fixes

### Version Numbering
This project follows [Semantic Versioning](https://semver.org/):
- **MAJOR** version for incompatible API changes
- **MINOR** version for backwards-compatible functionality additions
- **PATCH** version for backwards-compatible bug fixes

### Attribution
**Created by**: [Cagri Sarigoz](https://github.com/cagrisarigoz)  
**License**: MIT  
**Repository**: [https://github.com/cagrisarigoz/image-optimization](https://github.com/cagrisarigoz/image-optimization)

## [1.1.2] - 2025-05-29

### 🔄 Final Refactor & Organization

#### Added
- **Organized Data Structure**: Created `data/` folder with `input/`, `output/`, `examples/`, and `local_images/` subfolders
- **Example Files**: Added sample files in `data/examples/` for reference (not ignored by git)
  - `images_to_download_and_upload.csv` - Sample input format
  - `images_mapping.csv` - Sample output format  
  - `uploaded_files.json` - Sample state tracking
  - `local_files_alt_text.csv` - Sample alt text output
- Open source project setup with MIT License
- Comprehensive contribution guidelines and templates
- GitHub workflows for CI/CD automation
- Issue and pull request templates
- Automated welcome messages for new contributors
- Project rules documentation for AI models and developers

#### Changed
- **File Organization**: Moved all data files to organized folder structure
  - Input files: `data/input/`
  - Output files: `data/output/`
  - Example files: `data/examples/`
  - Local images: `data/local_images/` (moved from `images_to_upload/`)
- **Simplified .gitignore**: Removed redundant entries and organized by category
- **Updated File Paths**: All scripts now use the new data folder structure
- **Enhanced Setup**: `setup.py` now creates the complete folder structure
- **PROJECT_RULES.md**: Now references CHANGELOG.md for version history instead of maintaining separate versions
- **Python Version Support**: Updated to support Python 3.9-3.13 (dropped 3.7-3.8)
- **Recommended Python Version**: Python 3.13 for best performance and compatibility
- **CI/CD Testing**: Updated to test against Python 3.9, 3.10, 3.11, 3.12, and 3.13
- Updated README with comprehensive virtual environment setup instructions
- Enhanced documentation structure and organization
- **Virtual Environment Support**:
  - Detailed Python 3.13 virtual environment setup instructions
  - Cross-platform virtual environment activation commands
  - Virtual environment benefits and best practices documentation
  - Development environment setup guidelines

#### Removed
- **images_to_upload folder**: Replaced with organized `data/local_images/` structure

#### Fixed
- **CSV Writing Bug**: Fixed issue when alt text generation is disabled but existing mappings contain alt text
- **Path References**: Updated all documentation and scripts to use new file paths

#### Technical Details
- Maintained backward compatibility for existing functionality
- All example files use realistic sample data
- Improved project organization following best practices
- Enhanced user experience with clearer file structure