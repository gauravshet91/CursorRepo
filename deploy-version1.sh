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

echo "🚀 DEPLOY NOTES APP VERSION 1.0"
echo "==============================="

# Stop any existing containers
print_status "Stopping existing containers..."
docker stop notes-app-v1 2>/dev/null || true
docker rm notes-app-v1 2>/dev/null || true

# Pull the latest version
print_status "Pulling version 1.0 from Docker Hub..."
docker pull gauravshet91/notesapp1:v1.0

if [ $? -eq 0 ]; then
    print_success "Version 1.0 pulled successfully"
else
    print_warning "Could not pull from Docker Hub, using local image"
fi

# Run the container
print_status "Starting Notes App Version 1.0..."
docker run -d \
  --name notes-app-v1 \
  -p 8080:8080 \
  -p 8443:8443 \
  -p 8444:8444 \
  -v notes_data:/app/data \
  gauravshet91/notesapp1:v1.0

if [ $? -eq 0 ]; then
    print_success "Container started successfully"
else
    print_error "Failed to start container"
    exit 1
fi

# Wait for startup
print_status "Waiting for application to start..."
sleep 15

# Test the application
print_status "Testing application..."

# Test HTTP
if curl -s http://localhost:8080 > /dev/null; then
    print_success "✅ HTTP (port 8080): Working"
else
    print_warning "❌ HTTP (port 8080): Failed"
fi

# Test HTTPS
if curl -s -k https://localhost:8443 > /dev/null; then
    print_success "✅ HTTPS (port 8443): Working"
else
    print_warning "❌ HTTPS (port 8443): Failed"
fi

# Test HTTP/2
if curl -s -k https://localhost:8444 > /dev/null; then
    print_success "✅ HTTP/2 (port 8444): Working"
else
    print_warning "❌ HTTP/2 (port 8444): Failed"
fi

# Test API
if curl -s http://localhost:8080/api/user | grep -q "Authentication required"; then
    print_success "✅ API: Working"
else
    print_warning "❌ API: Failed"
fi

echo ""
print_success "🎉 NOTES APP VERSION 1.0 DEPLOYED!"
echo "============================================="
echo ""
print_status "🌐 ACCESS POINTS:"
echo "  🌐 HTTP:  http://localhost:8080"
echo "  🔐 HTTPS: https://localhost:8443"
echo "  ⚡ HTTP/2: https://localhost:8444"
echo ""
print_status "👤 LOGIN CREDENTIALS:"
echo "  Username: admin"
echo "  Password: admin123"
echo ""
print_status "📋 FEATURES:"
echo "  ✅ Single Container Solution"
echo "  ✅ Multi-Protocol Support"
echo "  ✅ User Authentication"
echo "  ✅ Notes Management"
echo "  ✅ Admin Panel"
echo "  ✅ Idle Timeout Management"
echo "  ✅ User Management"
echo "  ✅ Database Persistence"
echo ""
print_success "🚀 VERSION 1.0 IS READY TO USE!"
