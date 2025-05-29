#!/usr/bin/env python3
"""
CloudFront Image Upload Utility Setup Script

This script helps you set up the environment and verify all prerequisites.
Run this before using the image upload utility for the first time.
"""

import csv
import json
import os
import subprocess
import sys


def check_python_version():
    """Check if Python version is 3.7 or higher"""
    print("🐍 Checking Python version...")
    if sys.version_info < (3, 7):
        print("❌ Python 3.7+ is required. Current version:", sys.version)
        return False
    print(f"✅ Python {sys.version.split()[0]} is compatible")
    return True


def check_dependencies():
    """Check if required packages are installed"""
    print("\n📦 Checking dependencies...")
    required_packages = ["boto3", "flask", "pillow", "requests", "python-dotenv"]
    missing_packages = []

    for package in required_packages:
        try:
            if package == "python-dotenv":
                __import__("dotenv")
            else:
                __import__(package.lower())
            print(f"✅ {package} is installed")
        except ImportError:
            print(f"❌ {package} is missing")
            missing_packages.append(package)

    if missing_packages:
        print(f"\n🔧 Installing missing packages: {', '.join(missing_packages)}")
        try:
            subprocess.check_call(
                [sys.executable, "-m", "pip", "install"] + missing_packages
            )
            print("✅ All dependencies installed successfully")
            return True
        except subprocess.CalledProcessError:
            print("❌ Failed to install dependencies. Please install manually:")
            print(f"   pip install {' '.join(missing_packages)}")
            return False

    return True


def create_directories():
    """Create necessary directories"""
    print("📁 Creating directories...")

    # Create main directories
    directories = [
        "data",
        "data/input",
        "data/output",
        "data/examples",
        "data/local_images",
    ]

    for directory in directories:
        if not os.path.exists(directory):
            os.makedirs(directory)
            print(f"✅ Created {directory}/ directory")
        else:
            print(f"✅ {directory}/ directory already exists")


def create_sample_files():
    """Create sample CSV file if it doesn't exist"""
    print("📄 Creating sample files...")

    # Create sample input file
    csv_file = "data/input/images_to_download_and_upload.csv"
    if not os.path.exists(csv_file):
        with open(csv_file, "w", newline="") as f:
            writer = csv.writer(f)
            writer.writerow(["URL"])
            writer.writerow(["https://example.com/sample-image.jpg"])
        print(f"✅ Created sample {csv_file}")
    else:
        print(f"✅ {csv_file} already exists")


def create_env_file():
    """Create environment file template if it doesn't exist"""
    print("\n🔑 Checking environment configuration...")

    env_file = ".env"
    env_example = "env.example"

    if not os.path.exists(env_file):
        if os.path.exists(env_example):
            # Copy from example
            with open(env_example, "r") as src, open(env_file, "w") as dst:
                dst.write(src.read())
            print(f"✅ Created {env_file} from template")
            print("⚠️  Please edit .env file and add your AltText.ai API key")
        else:
            # Create basic env file
            with open(env_file, "w") as f:
                f.write("# AltText.ai API Configuration\n")
                f.write("ALTTEXT_AI_API_KEY=your_alttext_ai_api_key_here\n")
                f.write("\n# Optional: Custom keywords for SEO optimization\n")
                f.write("ALTTEXT_AI_KEYWORDS=\n")
                f.write("\n# Optional: Webhook URL for asynchronous processing\n")
                f.write("ALTTEXT_AI_WEBHOOK_URL=\n")
            print(f"✅ Created {env_file}")
            print("⚠️  Please edit .env file and add your AltText.ai API key")
    else:
        print(f"✅ {env_file} already exists")

        # Check if API key is configured
        try:
            with open(env_file, "r") as f:
                content = f.read()
                if "your_alttext_ai_api_key_here" in content:
                    print("⚠️  Please update ALTTEXT_AI_API_KEY in .env file")
                    return False
                elif "ALTTEXT_AI_API_KEY=" in content:
                    print("✅ AltText.ai API key appears to be configured")
                    return True
        except Exception:
            pass

    return True


def check_aws_config():
    """Check AWS configuration in upload_files.py"""
    print("\n☁️  Checking AWS configuration...")

    try:
        with open("upload_files.py", "r") as f:
            content = f.read()

        if "your_access_key" in content or "your_secret_key" in content:
            print("⚠️  AWS credentials need to be configured in upload_files.py")
            print("   Update lines 18-21 with your actual AWS credentials")
            return False

        # Check if actual credentials are present (basic check)
        if "AWS_ACCESS_KEY = " in content and "AWS_SECRET_KEY = " in content:
            print("✅ AWS credentials appear to be configured")
            return True
        else:
            print("❌ AWS credentials not found in upload_files.py")
            return False

    except FileNotFoundError:
        print("❌ upload_files.py not found")
        return False


def run_basic_test():
    """Run a basic import test"""
    print("\n🧪 Running basic functionality test...")

    try:
        # Test if we can import the main module
        sys.path.insert(0, ".")
        from upload_files import load_uploaded_files

        # Test basic function
        uploaded_files = load_uploaded_files()
        print("✅ Core functionality test passed")
        return True

    except Exception as e:
        print(f"❌ Basic test failed: {e}")
        return False


def test_alttext_ai():
    """Test AltText.ai API connection if configured"""
    print("\n🔍 Testing AltText.ai connection...")

    try:
        # Try to import and test
        from alttext_ai import test_alttext_ai_connection

        if test_alttext_ai_connection():
            print("✅ AltText.ai API connection successful")
            return True
        else:
            print("❌ AltText.ai API connection failed")
            print("   Check your API key in .env file")
            return False

    except ImportError:
        print("⚠️  AltText.ai module not available (this is optional)")
        return True  # Not an error, just not available
    except Exception as e:
        print(f"⚠️  AltText.ai test failed: {e}")
        return True  # Not critical for basic functionality


def main():
    """Main setup function"""
    print("🚀 CloudFront Image Upload Utility Setup")
    print("=" * 50)

    checks = [
        check_python_version(),
        check_dependencies(),
    ]

    # Always create directories and files
    create_directories()
    create_sample_files()
    env_config_ok = create_env_file()

    # Check AWS config
    aws_config_ok = check_aws_config()

    # Test AltText.ai if configured
    alttext_ok = test_alttext_ai()

    # Run basic test
    basic_test_ok = run_basic_test()

    print("\n" + "=" * 50)
    print("📋 Setup Summary:")

    if all(checks) and basic_test_ok:
        print("✅ Environment setup completed successfully!")
        print("")
        print("🎉 You're ready to start uploading images!")
        if alttext_ok:
            print("📄 Alt text generation is available!")
        print("Run: ./process_csv.sh")
        print("")
        print("📁 File locations:")
        print("   Input:  data/input/images_to_download_and_upload.csv")
        print("   Output: data/output/images_mapping.csv")
        print("   State:  data/output/uploaded_files.json")
    else:
        print("❌ Setup incomplete. Please fix the issues above.")
        print("")
        print("📋 Next steps:")
        print("1. Install missing dependencies")
        print("2. Configure your .env file with API keys")
        print("3. Test your AWS and AltText.ai connections")
        print("4. Add image URLs to data/input/images_to_download_and_upload.csv")
        sys.exit(1)


if __name__ == "__main__":
    main()
