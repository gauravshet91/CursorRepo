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

echo "🐳 PUSH TO DOCKER HUB - NOTESAPP2 VERSION 1.0"
echo "============================================="

print_status "📊 TAGGED IMAGES:"
echo "===================="
docker images | grep gauravshet91/notesapp2

echo ""
print_status "📋 DOCKER HUB PUSH INSTRUCTIONS:"
echo "======================================"
echo ""
echo "1. 🔐 LOGIN TO DOCKER HUB:"
echo "   Run: docker login"
echo "   Enter your Docker Hub username and password"
echo ""
echo "2. 🚀 PUSH VERSION 1.0:"
echo "   docker push gauravshet91/notesapp2:v1.0"
echo ""
echo "3. 🚀 PUSH LATEST VERSION:"
echo "   docker push gauravshet91/notesapp2:latest"
echo ""
echo "4. ✅ VERIFY UPLOAD:"
echo "   Check your Docker Hub repository: https://hub.docker.com/r/gauravshet91/notesapp2"
echo ""

print_status "🎯 READY TO PUSH:"
echo "===================="
echo "✅ Repository: gauravshet91/notesapp2"
echo "✅ Tag v1.0: gauravshet91/notesapp2:v1.0"
echo "✅ Tag latest: gauravshet91/notesapp2:latest"
echo "✅ Size: ~151MB"
echo "✅ All features included"
echo ""

print_status "🚀 DEPLOYMENT FOR USERS:"
echo "============================="
echo "docker pull gauravshet91/notesapp2:v1.0"
echo "docker run -d --name notes-app-v1 \\"
echo "  -p 8080:8080 -p 8443:8443 -p 8444:8444 \\"
echo "  -v notes_data:/app/data \\"
echo "  gauravshet91/notesapp2:v1.0"
echo ""

print_status "🌐 ACCESS POINTS:"
echo "===================="
echo "  🌐 HTTP:  http://localhost:8080"
echo "  🔐 HTTPS: https://localhost:8443"
echo "  ⚡ HTTP/2: https://localhost:8444"
echo ""

print_status "👤 LOGIN CREDENTIALS:"
echo "========================="
echo "  Username: admin"
echo "  Password: admin123"
echo ""

print_success "🎉 NOTESAPP2 VERSION 1.0 IS READY FOR DOCKER HUB!"
echo "Repository: gauravshet91/notesapp2"
echo "Tags: v1.0, latest"
