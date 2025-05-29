#!/bin/bash
# Pre-commit validation script
# Run this before making any commits to ensure code quality
# This script mirrors the CI pipeline checks to catch issues early

echo "🔍 Running comprehensive pre-commit checks..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Track if any checks fail
CHECKS_PASSED=true
AUTO_FIXES_APPLIED=false

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    if [ "$status" = "pass" ]; then
        echo -e "${GREEN}✅ $message${NC}"
    elif [ "$status" = "fail" ]; then
        echo -e "${RED}❌ $message${NC}"
        CHECKS_PASSED=false
    elif [ "$status" = "warn" ]; then
        echo -e "${YELLOW}⚠️  $message${NC}"
    elif [ "$status" = "info" ]; then
        echo -e "${BLUE}ℹ️  $message${NC}"
    elif [ "$status" = "fix" ]; then
        echo -e "${YELLOW}🔧 $message${NC}"
        AUTO_FIXES_APPLIED=true
    fi
}

# Function to check if a command exists
check_command() {
    if ! command -v "$1" &> /dev/null; then
        print_status "fail" "$1 is not installed. Run: pip install $1"
        return 1
    fi
    return 0
}

# Function to ask for user confirmation
ask_user() {
    local message=$1
    echo -e "${YELLOW}❓ $message (y/N): ${NC}"
    read -r response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

echo "📋 Step 1: Checking required tools..."

# Check if required tools are installed
REQUIRED_TOOLS=("black" "isort" "flake8" "bandit" "safety")
for tool in "${REQUIRED_TOOLS[@]}"; do
    if check_command "$tool"; then
        print_status "pass" "$tool is installed"
    fi
done

# Install missing tools if any
if [ "$CHECKS_PASSED" = false ]; then
    echo ""
    if ask_user "Install missing tools automatically?"; then
        print_status "fix" "Installing missing tools..."
        pip install black isort flake8 bandit safety autopep8
        echo ""
        CHECKS_PASSED=true  # Reset for the rest of the checks
    else
        print_status "info" "Please install missing tools manually: pip install black isort flake8 bandit safety autopep8"
        echo ""
    fi
fi

echo ""
echo "🏗️  Step 2: Validating project structure..."

# Check core files exist
REQUIRED_FILES=(
    "upload_files.py"
    "alttext_ai.py" 
    "setup.py"
    "requirements.txt"
    "process_csv.sh"
    ".env.example"
    "README.md"
    "CONTRIBUTING.md"
    "LICENSE"
    "PROJECT_RULES.md"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        print_status "pass" "$file exists"
    else
        print_status "fail" "Required file $file is missing"
    fi
done

# Check directories exist and create if missing
if [ -d "data" ]; then
    print_status "pass" "data directory exists"
else
    print_status "fix" "Creating data directory..."
    mkdir -p data
fi

# Check data subdirectories exist and create if missing
DATA_DIRS=("input" "output" "local_images" "examples")
for dir in "${DATA_DIRS[@]}"; do
    if [ -d "data/$dir" ]; then
        print_status "pass" "data/$dir directory exists"
    else
        print_status "fix" "Creating data/$dir directory..."
        mkdir -p "data/$dir"
        # Add .gitkeep files only if directory is empty (to ensure directories are tracked)
        if [ -z "$(ls -A "data/$dir" 2>/dev/null)" ]; then
            touch "data/$dir/.gitkeep"
        fi
    fi
done

# Check shell script is executable and fix if needed
if [ -x "process_csv.sh" ]; then
    print_status "pass" "process_csv.sh is executable"
else
    print_status "fix" "Making process_csv.sh executable..."
    chmod +x process_csv.sh
fi

echo ""
echo "📝 Step 3: Code formatting..."

print_status "info" "Formatting code with black..."
if black .; then
    print_status "pass" "Code formatting completed"
else
    print_status "fail" "Black formatting failed"
fi

print_status "info" "Sorting imports with isort..."
if isort .; then
    print_status "pass" "Import sorting completed"
else
    print_status "fail" "Import sorting failed"
fi

echo ""
echo "🔍 Step 4: Code quality checks..."

print_status "info" "Running flake8 linting..."
if flake8 --exclude=venv --max-line-length=127 --extend-ignore=E203,W503 .; then
    print_status "pass" "All linting checks passed"
else
    print_status "warn" "Linting errors found. Attempting to auto-fix..."
    
    # Try to auto-fix with autopep8
    if command -v autopep8 &> /dev/null; then
        print_status "fix" "Auto-fixing with autopep8..."
        autopep8 --in-place --aggressive --aggressive --max-line-length=127 *.py
        
        # Re-run flake8 to check if issues are resolved
        if flake8 --exclude=venv --max-line-length=127 --extend-ignore=E203,W503 .; then
            print_status "pass" "Auto-fix successful - all linting checks now pass"
        else
            print_status "fail" "Some linting errors could not be auto-fixed. Manual review needed."
        fi
    else
        if ask_user "Install autopep8 to auto-fix linting issues?"; then
            pip install autopep8
            print_status "fix" "Auto-fixing with autopep8..."
            autopep8 --in-place --aggressive --aggressive --max-line-length=127 *.py
            
            # Re-run flake8 to check if issues are resolved
            if flake8 --exclude=venv --max-line-length=127 --extend-ignore=E203,W503 .; then
                print_status "pass" "Auto-fix successful - all linting checks now pass"
            else
                print_status "fail" "Some linting errors could not be auto-fixed. Manual review needed."
            fi
        else
            print_status "fail" "Linting errors found and auto-fix declined"
        fi
    fi
fi

echo ""
echo "🔒 Step 5: Security checks..."

print_status "info" "Running bandit security check..."
if bandit -r . -x ./tests/,./venv/ --severity-level medium --quiet; then
    print_status "pass" "No security issues found by bandit"
else
    print_status "fail" "Security issues found by bandit"
    print_status "info" "💡 Run 'bandit -r . -x ./tests/,./venv/' for detailed security report"
fi

print_status "info" "Checking for known vulnerabilities with safety..."
if safety scan --short-report --output text 2>/dev/null; then
    print_status "pass" "No known vulnerabilities found"
else
    print_status "warn" "Known vulnerabilities found in dependencies"
    
    if ask_user "Would you like to see vulnerable packages and suggested fixes?"; then
        echo ""
        print_status "info" "Vulnerability details:"
        safety scan --output text
        echo ""
        
        if ask_user "Attempt to update vulnerable packages automatically?"; then
            print_status "fix" "Updating vulnerable packages..."
            
            # Get list of vulnerable packages and try to update them
            vulnerable_packages=$(safety scan --output json 2>/dev/null | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    if 'vulnerabilities' in data:
        packages = set()
        for vuln in data['vulnerabilities']:
            if 'package_name' in vuln:
                packages.add(vuln['package_name'])
        print(' '.join(packages))
except:
    pass
" 2>/dev/null)
            
            if [ -n "$vulnerable_packages" ]; then
                print_status "fix" "Updating packages: $vulnerable_packages"
                pip install --upgrade $vulnerable_packages
                print_status "info" "Re-running security scan..."
                if safety scan --short-report --output text 2>/dev/null; then
                    print_status "pass" "Vulnerabilities resolved!"
                else
                    print_status "warn" "Some vulnerabilities may still remain. Manual review recommended."
                fi
            else
                print_status "info" "Could not determine specific packages to update"
            fi
        fi
    fi
fi

echo ""
echo "🧪 Step 6: Import and functionality tests..."

print_status "info" "Testing Python imports..."
if python -c "import upload_files; print('upload_files imports successfully')" 2>/dev/null; then
    print_status "pass" "upload_files imports successfully"
else
    print_status "fail" "upload_files import failed"
fi

if python -c "import alttext_ai; print('alttext_ai imports successfully')" 2>/dev/null; then
    print_status "pass" "alttext_ai imports successfully"
else
    print_status "fail" "alttext_ai import failed"
fi

print_status "info" "Testing core functionality..."
if python -c "from upload_files import optimize_image, get_best_format; from alttext_ai import AltTextAI; print('Core functions available')" 2>/dev/null; then
    print_status "pass" "Core functions import successfully"
else
    print_status "fail" "Core function imports failed"
fi

echo ""
echo "📚 Step 7: Documentation checks..."

# Check README has basic sections
if grep -q "## 🚀 Features" README.md 2>/dev/null; then
    print_status "pass" "README has Features section"
else
    print_status "fail" "README missing Features section"
fi

if grep -q "## 🛠 Installation" README.md 2>/dev/null; then
    print_status "pass" "README has Installation section"
else
    print_status "fail" "README missing Installation section"
fi

# Check .env.example has required variables
REQUIRED_ENV_VARS=(
    "ALTTEXT_AI_API_KEY"
    "ALTTEXT_AI_KEYWORDS"
    "ALTTEXT_AI_WEBHOOK_URL"
)

for var in "${REQUIRED_ENV_VARS[@]}"; do
    if grep -q "$var" .env.example 2>/dev/null; then
        print_status "pass" "$var found in .env.example"
    else
        print_status "fail" "$var missing from .env.example"
    fi
done

echo ""
echo "📄 Step 8: Git status check..."

# Check if there are any uncommitted changes after formatting
if [[ -n $(git status --porcelain) ]]; then
    print_status "warn" "Code formatting/fixes created changes. Please review:"
    git status --short
    echo ""
    
    if [ "$AUTO_FIXES_APPLIED" = true ]; then
        print_status "info" "🔧 Auto-fixes were applied during this run"
        if ask_user "Commit the auto-fixes automatically?"; then
            git add .
            git commit -m "style: apply automated pre-commit fixes

- Auto-format code with black and isort
- Fix linting issues with autopep8
- Create missing directories and .gitkeep files
- Fix file permissions"
            print_status "fix" "Auto-fixes committed successfully"
        else
            print_status "info" "💡 Tip: Run 'git add . && git commit -m \"style: apply automated fixes\"'"
        fi
    else
        print_status "info" "💡 Tip: Run 'git add . && git commit -m \"style: auto-format code\"'"
    fi
else
    print_status "pass" "No formatting changes needed"
fi

echo ""
echo "============================================================"

# Final status
if [ "$CHECKS_PASSED" = true ]; then
    print_status "pass" "🎉 All pre-commit checks passed! Code is ready for commit."
    echo ""
    if [ "$AUTO_FIXES_APPLIED" = true ]; then
        print_status "info" "🔧 Auto-fixes were applied to resolve issues automatically."
    fi
    print_status "info" "Your code meets all CI pipeline requirements and should pass all GitHub Actions checks."
    exit 0
else
    print_status "fail" "❌ Some pre-commit checks failed. Please fix the remaining issues above."
    echo ""
    if [ "$AUTO_FIXES_APPLIED" = true ]; then
        print_status "info" "🔧 Some issues were auto-fixed, but manual intervention is needed for the rest."
    fi
    print_status "info" "💡 These are the same checks that run in the CI pipeline - fixing them now will save time later."
    exit 1
fi 