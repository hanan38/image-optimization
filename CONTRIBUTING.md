# Contributing to CloudFront Image Upload Utility

Thank you for your interest in contributing to the CloudFront Image Upload Utility! This document provides guidelines and information for contributors.

## 🎯 Project Overview

This project is a comprehensive tool for downloading, optimizing, and uploading images to AWS S3 with CloudFront distribution, featuring AI-powered alt text generation. Created by **Cagri Sarigoz**, it's designed to help developers and content creators optimize their image workflows.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)
- [Issue Reporting](#issue-reporting)
- [Feature Requests](#feature-requests)
- [Community](#community)

## 📜 Code of Conduct

This project adheres to a code of conduct that we expect all contributors to follow:

- **Be respectful**: Treat everyone with respect and kindness
- **Be inclusive**: Welcome newcomers and help them get started
- **Be collaborative**: Work together to improve the project
- **Be constructive**: Provide helpful feedback and suggestions
- **Be patient**: Remember that everyone has different skill levels

## 🚀 Getting Started

### Prerequisites

- Python 3.9+ (Recommended: Python 3.13)
- Git
- AWS account (for testing S3/CloudFront features)
- AltText.ai API key (optional, for alt text features)

### Quick Setup

1. **Fork the repository**
   ```bash
   # Click the "Fork" button on GitHub
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/image-optimization.git
   cd image-optimization
   ```

3. **Set up the development environment**
   ```bash
   # Create virtual environment (recommended)
   python3.13 -m venv venv
   source venv/bin/activate  # Linux/macOS
   # or venv\Scripts\activate  # Windows
   
   # Install dependencies
   pip install -r requirements.txt
   
   # Run setup script
   python setup.py
   
   # Copy environment template
   cp env.example .env
   # Edit .env with your credentials
   ```

4. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/cagrisarigoz/image-optimization.git
   ```

## 🛠 Development Setup

### Recommended: Python 3.13 Virtual Environment

For the best development experience, we recommend using Python 3.13 with a virtual environment:

#### Install Python 3.13

**macOS (using Homebrew):**
```bash
brew install python@3.13
```

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install python3.13 python3.13-venv python3.13-pip
```

**Windows:**
Download from [python.org](https://www.python.org/downloads/) or use Windows Store.

#### Create Development Environment

```bash
# Create virtual environment
python3.13 -m venv venv

# Activate virtual environment
source venv/bin/activate  # Linux/macOS
# or
venv\Scripts\activate     # Windows

# Verify Python version
python --version  # Should show Python 3.13.x

# Upgrade pip
python -m pip install --upgrade pip

# Install dependencies
pip install -r requirements.txt

# Install development tools
pip install flake8 black isort mypy bandit safety
```

### Environment Configuration

1. **Create `.env` file** (never commit this):
   ```bash
   # AWS Configuration (Required for testing)
   AWS_ACCESS_KEY=your_aws_access_key
   AWS_SECRET_KEY=your_aws_secret_key
   S3_BUCKET=your_test_bucket
   CLOUDFRONT_DOMAIN=your_test_domain
   
   # AltText.ai Configuration (Optional)
   ALTTEXT_AI_API_KEY=your_api_key
   ALTTEXT_AI_KEYWORDS=test,development
   ```

2. **Test your setup**:
   ```bash
   # Test basic functionality
   python upload_files.py
   
   # Test AltText.ai integration (if configured)
   python alttext_ai.py
   
   # Test CSV processing
   ./process_csv.sh
   ```

### Development Workflow

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following our [coding standards](#coding-standards)

3. **Test thoroughly**:
   ```bash
   # Test core functionality
   python upload_files.py
   
   # Test with sample images
   ./process_csv.sh
   
   # Test API endpoints
   export FLASK_RUN=1
   python upload_files.py
   ```

4. **Run code quality checks**:
   ```bash
   # Format code
   black .
   isort .
   
   # Lint code
   flake8 .
   
   # Security check
   bandit -r .
   
   # Check dependencies
   safety check
   ```

5. **Commit with clear messages**:
   ```bash
   git add .
   git commit -m "feat: add new image format support"
   ```

## 🤝 How to Contribute

### Types of Contributions

We welcome various types of contributions:

- **🐛 Bug fixes**: Fix issues and improve stability
- **✨ New features**: Add new functionality
- **📚 Documentation**: Improve docs, examples, and guides
- **🎨 UI/UX improvements**: Enhance user experience
- **⚡ Performance**: Optimize code and processes
- **🧪 Testing**: Add tests and improve coverage
- **🔧 Tooling**: Improve development tools and workflows

### Contribution Areas

#### High Priority
- **Image format support**: Add support for new formats (AVIF, HEIF, etc.)
- **Performance optimization**: Improve processing speed and memory usage
- **Error handling**: Better error messages and recovery
- **Testing**: Add comprehensive test suite
- **Documentation**: Improve examples and tutorials

#### Medium Priority
- **API enhancements**: New endpoints and features
- **Configuration options**: More customization options
- **Monitoring**: Add metrics and logging
- **Security**: Improve security practices

#### Low Priority
- **UI improvements**: Better CLI interface
- **Integration**: Support for other cloud providers
- **Automation**: Additional workflow automations

## 🔄 Pull Request Process

### Before Submitting

1. **Check existing issues**: Look for related issues or discussions
2. **Follow coding standards**: Ensure your code follows our guidelines
3. **Test thoroughly**: Test your changes with various scenarios
4. **Update documentation**: Update relevant docs and examples
5. **Write clear commit messages**: Use conventional commit format

### PR Guidelines

1. **Create a clear title**:
   ```
   feat: add WebP optimization support
   fix: resolve S3 upload timeout issues
   docs: improve installation instructions
   ```

2. **Provide detailed description**:
   ```markdown
   ## Description
   Brief description of changes
   
   ## Changes Made
   - List of specific changes
   - Any breaking changes
   
   ## Testing
   - How you tested the changes
   - Test cases covered
   
   ## Screenshots (if applicable)
   - Before/after screenshots
   ```

3. **Link related issues**:
   ```markdown
   Fixes #123
   Relates to #456
   ```

### Review Process

1. **Automated checks**: CI/CD will run automated tests
2. **Code review**: Maintainers will review your code
3. **Feedback**: Address any feedback or requested changes
4. **Approval**: Once approved, your PR will be merged

## 📝 Coding Standards

### Python Style

Follow the guidelines in [PROJECT_RULES.md](PROJECT_RULES.md):

- **PEP 8**: Follow Python style guidelines
- **Type hints**: Use type hints where appropriate
- **Docstrings**: Document all functions and classes
- **Error handling**: Use consistent error patterns
- **Logging**: Use emoji prefixes for clarity

### Code Quality Tools

We use several tools to maintain code quality:

```bash
# Format code with Black
black .

# Sort imports with isort
isort .

# Lint with flake8
flake8 . --max-line-length=127 --extend-ignore=E203,W503

# Type checking with mypy
mypy . --ignore-missing-imports

# Security scanning with bandit
bandit -r .

# Dependency vulnerability check
safety check
```

### Example Code Style

```python
def optimize_image(image_path: str, max_width: Optional[int] = None, 
                  quality: int = 82, smart_format: bool = True) -> Tuple[bool, str]:
    """
    Optimize an image by resizing, adjusting quality, and choosing the best format
    
    Args:
        image_path: Path to the image file
        max_width: Maximum width for resizing (None = no resizing)
        quality: JPEG/WebP quality (1-100)
        smart_format: Enable smart format selection
        
    Returns:
        Tuple of (success: bool, optimized_path: str)
        
    Raises:
        FileNotFoundError: If image file doesn't exist
        ValueError: If quality is not in valid range
    """
    try:
        # Implementation here
        print(f"✅ Image optimized successfully: {image_path}")
        return True, optimized_path
    except Exception as e:
        print(f"❌ Failed to optimize image: {e}")
        return False, image_path
```

## 🧪 Testing Guidelines

### Manual Testing

Test your changes with:

```bash
# Test with different Python versions (if available)
python3.9 upload_files.py
python3.10 upload_files.py
python3.11 upload_files.py
python3.12 upload_files.py
python3.13 upload_files.py

# Core functionality
python upload_files.py

# CSV processing
./process_csv.sh

# API endpoints
export FLASK_RUN=1
python upload_files.py
curl -X POST -F "file=@test.jpg" http://localhost:5000/upload

# AltText.ai integration
python alttext_ai.py https://example.com/test.jpg
```

### Test Cases to Cover

- **Image formats**: JPEG, PNG, WebP, GIF
- **Various sizes**: Small, medium, large images
- **Error scenarios**: Invalid files, network issues, API failures
- **Configuration**: Different quality settings, max width values
- **Alt text**: With and without keywords
- **Python versions**: Test on supported versions (3.9-3.13)

### Future Testing

We're working on adding automated testing. Contributions to testing infrastructure are highly welcome!

## 📚 Documentation

### Documentation Standards

- **Clear examples**: Provide working code examples
- **Step-by-step guides**: Break down complex processes
- **Screenshots**: Include visual aids where helpful
- **Keep updated**: Update docs when making changes

### Areas Needing Documentation

- **API reference**: Complete endpoint documentation
- **Tutorials**: Step-by-step guides for common use cases
- **Troubleshooting**: Common issues and solutions
- **Examples**: Real-world usage examples

## 🐛 Issue Reporting

### Before Creating an Issue

1. **Search existing issues**: Check if the issue already exists
2. **Check documentation**: Review README and troubleshooting guides
3. **Test with latest version**: Ensure you're using the latest code

### Bug Report Template

```markdown
**Bug Description**
Clear description of the bug

**Steps to Reproduce**
1. Step one
2. Step two
3. Step three

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Environment**
- OS: [e.g., macOS 12.0]
- Python version: [e.g., 3.13.0]
- Project version: [e.g., latest main branch]

**Additional Context**
- Error messages
- Screenshots
- Configuration details (without sensitive info)
```

## ✨ Feature Requests

### Feature Request Template

```markdown
**Feature Description**
Clear description of the proposed feature

**Use Case**
Why is this feature needed? What problem does it solve?

**Proposed Solution**
How should this feature work?

**Alternatives Considered**
Other solutions you've considered

**Additional Context**
- Examples from other tools
- Implementation ideas
- Potential challenges
```

## 👥 Community

### Getting Help

- **GitHub Issues**: For bugs and feature requests
- **GitHub Discussions**: For questions and general discussion
- **Documentation**: Check README and project docs first

### Recognition

Contributors will be recognized in:
- **README.md**: Contributors section
- **Release notes**: Major contributions highlighted
- **GitHub**: Contributor badges and stats

### Maintainers

- **Cagri Sarigoz** ([@cagrisarigoz](https://github.com/cagrisarigoz)) - Creator and Lead Maintainer

## 📄 License

By contributing to this project, you agree that your contributions will be licensed under the MIT License. See [LICENSE](LICENSE) for details.

## 🙏 Thank You

Thank you for contributing to the CloudFront Image Upload Utility! Your contributions help make this tool better for everyone.

---

**Questions?** Feel free to open an issue or start a discussion. We're here to help! 