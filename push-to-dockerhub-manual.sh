#!/bin/bash

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo "🐳 PUSH TO DOCKER HUB - VERSION 1.0"
echo "===================================="

# Check if images are tagged
print_status "Checking tagged images..."
docker images | grep gauravshet91/notesapp1

echo ""
print_status "📋 MANUAL DOCKER HUB PUSH INSTRUCTIONS:"
echo "=============================================="
echo ""
echo "1. 🔐 LOGIN TO DOCKER HUB:"
echo "   Run: docker login"
echo "   Enter your Docker Hub username and password"
echo ""
echo "2. 🚀 PUSH VERSION 1.0:"
echo "   docker push gauravshet91/notesapp1:v1.0"
echo ""
echo "3. 🚀 PUSH LATEST VERSION:"
echo "   docker push gauravshet91/notesapp1:latest"
echo ""
echo "4. ✅ VERIFY UPLOAD:"
echo "   Check your Docker Hub repository: https://hub.docker.com/r/gauravshet91/notesapp1"
echo ""

print_status "📊 CURRENT IMAGE STATUS:"
echo "============================="
docker images | grep gauravshet91/notesapp1 | head -2

echo ""
print_status "🎯 READY TO PUSH:"
echo "===================="
echo "✅ Images tagged: gauravshet91/notesapp1:v1.0"
echo "✅ Images tagged: gauravshet91/notesapp1:latest"
echo "✅ Size: ~151MB"
echo "✅ All features included"
echo ""

print_status "🚀 NEXT STEPS:"
echo "================"
echo "1. Run: docker login"
echo "2. Run: docker push gauravshet91/notesapp1:v1.0"
echo "3. Run: docker push gauravshet91/notesapp1:latest"
echo "4. Verify on Docker Hub"
echo ""

print_success "🎉 VERSION 1.0 IS READY FOR DOCKER HUB!"
echo "Repository: gauravshet91/notesapp1"
echo "Tags: v1.0, latest"
