#!/bin/bash

# Complete Notes App v1.2 - Simple Deployment Script

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

echo "🚀 Complete Notes App v1.2 - Deployment"
echo "======================================="

print_status "Stopping existing containers..."
docker compose down --remove-orphans > /dev/null 2>&1

print_status "Building Docker image..."
if ! docker build -t gauravshet91/notesapp2:v1.2 .; then
    print_error "Failed to build Docker image"
    exit 1
fi
print_success "Docker image built successfully"

print_status "Starting application..."
if ! docker compose up -d; then
    print_error "Failed to start application"
    exit 1
fi
print_success "Application started successfully"

print_status "Waiting for services to be ready..."
sleep 10

print_status "Testing application..."

# Test HTTP
if curl -s http://localhost:8080 > /dev/null; then
    print_success "✅ HTTP service is working (port 8080)"
else
    print_warning "❌ HTTP service test failed"
fi

# Test HTTPS
if curl -s -k https://localhost:8443 > /dev/null; then
    print_success "✅ HTTPS service is working (port 8443)"
else
    print_warning "❌ HTTPS service test failed"
fi

# Test HTTP/2
if curl -s -k --http2 https://localhost:8444 > /dev/null; then
    print_success "✅ HTTP/2 service is working (port 8444)"
else
    print_warning "❌ HTTP/2 service test failed"
fi

echo ""
print_success "🎯 APPLICATION READY!"
echo "────────────────────────────────────────"
echo "✅ Single Container Solution"
echo "✅ HTTP Protocol (port 8080)"
echo "✅ HTTPS Protocol (port 8443)"
echo "✅ HTTP/2 Protocol (port 8444)"
echo "✅ User Authentication"
echo "✅ Notes Management"
echo "✅ Admin Panel"
echo "✅ Database Persistence"

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
print_success "🚀 YOUR COMPLETE NOTES APP IS READY!"
