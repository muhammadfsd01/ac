#!/bin/bash

# GitHub Connection Script (Error-Free Version)
# Save as 'deploy.sh' and run: chmod +x deploy.sh && ./deploy.sh

# Configuration
REPO_NAME="loanusa-website"
GITHUB_USER="YOUR_GITHUB_USERNAME"
BRANCH="main"

# Step 1: Verify Git Installation
if ! command -v git &> /dev/null; then
    echo "Error: Git is not installed. Please install Git first."
    exit 1
fi

# Step 2: Create Project Structure
mkdir -p $REPO_NAME/{assets/css,assets/js,assets/images,pages/verification}
cd $REPO_NAME

# Step 3: Initialize Repository
git init --quiet

# Step 4: Create Sample Files (from your structure)
touch index.html assets/css/style.css assets/js/script.js README.md .gitignore LICENSE
mkdir -p pages/{verification,eligibility,about,support,blog}
touch pages/{eligibility,about,support,blog}.html pages/verification/{credit,ach}-verification.html

# Step 5: Initial Commit
git add . > /dev/null
git commit -m "Initial commit: Project structure" --quiet

# Step 6: Create GitHub Repository
if command -v gh &> /dev/null; then
    gh repo create $REPO_NAME --public --confirm --disable-issues --disable-wiki > /dev/null
else
    echo "Note: GitHub CLI not found. Please create repository manually at:"
    echo "https://github.com/new?name=$REPO_NAME"
    read -p "Press Enter after creating the repository..."
fi

# Step 7: Set Remote Origin
git remote add origin https://github.com/$GITHUB_USER/$REPO_NAME.git 2> /dev/null || {
    git remote set-url origin https://github.com/$GITHUB_USER/$REPO_NAME.git
}

# Step 8: Push to GitHub
git branch -M $BRANCH
git push -u origin $BRANCH --force-with-lease > /dev/null 2>&1

# Step 9: Verify Connection
if git ls-remote --exit-code origin &> /dev/null; then
    echo -e "\033[32m✓ Successfully connected to GitHub!\033[0m"
    echo "Repository URL: https://github.com/$GITHUB_USER/$REPO_NAME"
else
    echo -e "\033[31m✗ Connection failed. Please check:\033[0m"
    echo "1. GitHub credentials"
    echo "2. Repository existence: https://github.com/$GITHUB_USER/$REPO_NAME"
    echo "3. Network connection"
fi

# Step 10: Enable GitHub Pages (Optional)
if command -v gh &> /dev/null; then
    gh repo edit $GITHUB_USER/$REPO_NAME --enable-pages --pages-branch=$BRANCH --pages-source=/
    echo -e "\n🌐 GitHub Pages enabled: https://$GITHUB_USER.github.io/$REPO_NAME"
fi
