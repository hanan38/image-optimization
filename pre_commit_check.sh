#!/bin/bash
# Pre-commit validation script
# Run this before making any commits to ensure code quality

echo "🔍 Running pre-commit checks..."

# Check if required tools are installed
if ! command -v black &> /dev/null; then
    echo "❌ black is not installed. Run: pip install black"
    exit 1
fi

if ! command -v isort &> /dev/null; then
    echo "❌ isort is not installed. Run: pip install isort"
    exit 1
fi

if ! command -v flake8 &> /dev/null; then
    echo "❌ flake8 is not installed. Run: pip install flake8"
    exit 1
fi

echo "📝 Formatting code with black..."
black .

echo "📋 Sorting imports with isort..."
isort .

echo "🔍 Running flake8 linting..."
if flake8 --exclude=venv --max-line-length=127 --extend-ignore=E203,W503 .; then
    echo "✅ All linting checks passed!"
else
    echo "❌ Linting errors found. Please fix before committing."
    exit 1
fi

# Check if there are any uncommitted changes after formatting
if [[ -n $(git status --porcelain) ]]; then
    echo "⚠️  Code formatting created changes. Please review and commit them:"
    git status --short
    echo ""
    echo "💡 Tip: Run 'git add . && git commit -m \"style: auto-format code\"'"
else
    echo "✅ No formatting changes needed."
fi

echo "🎉 All pre-commit checks passed! Code is ready for commit." 