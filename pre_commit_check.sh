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
    print_status "info" "Installing missing tools..."
    pip install black isort flake8 bandit safety
    echo ""
    CHECKS_PASSED=true  # Reset for the rest of the checks
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

# Check directories exist
if [ -d "data" ]; then
    print_status "pass" "data directory exists"
else
    print_status "fail" "data directory is missing"
fi

# Check data subdirectories exist
DATA_DIRS=("input" "output" "local_images" "examples")
for dir in "${DATA_DIRS[@]}"; do
    if [ -d "data/$dir" ]; then
        print_status "pass" "data/$dir directory exists"
    else
        print_status "fail" "data/$dir directory is missing"
    fi
done

# Check shell script is executable
if [ -x "process_csv.sh" ]; then
    print_status "pass" "process_csv.sh is executable"
else
    print_status "warn" "process_csv.sh is not executable - fixing..."
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
    print_status "fail" "Linting errors found"
fi

echo ""
echo "🔒 Step 5: Security checks..."

print_status "info" "Running bandit security check..."
if bandit -r . -x ./tests/,./venv/ --severity-level medium --quiet; then
    print_status "pass" "No security issues found by bandit"
else
    print_status "fail" "Security issues found by bandit"
fi

print_status "info" "Checking for known vulnerabilities with safety..."
if safety scan --short-report; then
    print_status "pass" "No known vulnerabilities found"
else
    print_status "fail" "Known vulnerabilities found in dependencies"
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
    print_status "warn" "Code formatting created changes. Please review and commit them:"
    git status --short
    echo ""
    print_status "info" "💡 Tip: Run 'git add . && git commit -m \"style: auto-format code\"'"
else
    print_status "pass" "No formatting changes needed"
fi

echo ""
echo "============================================================"

# Final status
if [ "$CHECKS_PASSED" = true ]; then
    print_status "pass" "🎉 All pre-commit checks passed! Code is ready for commit."
    echo ""
    print_status "info" "Your code meets all CI pipeline requirements and should pass all GitHub Actions checks."
    exit 0
else
    print_status "fail" "❌ Some pre-commit checks failed. Please fix the issues above before committing."
    echo ""
    print_status "info" "💡 These are the same checks that run in the CI pipeline - fixing them now will save time later."
    exit 1
fi 