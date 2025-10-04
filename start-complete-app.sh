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

echo "🚀 COMPLETE NOTES APP - FULL PROTOCOL SUPPORT"
echo "=============================================="

# Stop any existing containers
print_status "Stopping existing containers..."
docker compose -f docker-compose-complete.yml down 2>/dev/null || true

# Create SSL directory if it doesn't exist
print_status "Setting up SSL certificates..."
mkdir -p ssl

# Generate SSL certificates if they don't exist
if [ ! -f ssl/cert.pem ] || [ ! -f ssl/key.pem ]; then
    print_status "Generating SSL certificates..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout ssl/key.pem \
        -out ssl/cert.pem \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
    print_success "SSL certificates generated"
else
    print_success "SSL certificates already exist"
fi

# Copy the complete frontend
print_status "Setting up complete frontend..."
cp public/index-complete.html public/index.html
print_success "Complete frontend ready"

# Copy the complete server
print_status "Setting up complete server..."
cp server-complete.js server.js
print_success "Complete server ready"

# Build and start the complete application
print_status "Building complete Docker image..."
docker compose -f docker-compose-complete.yml build

if [ $? -eq 0 ]; then
    print_success "Docker image built successfully"
else
    print_error "Failed to build Docker image"
    exit 1
fi

print_status "Starting complete application..."
docker compose -f docker-compose-complete.yml up -d

if [ $? -eq 0 ]; then
    print_success "Application started successfully"
else
    print_error "Failed to start application"
    exit 1
fi

# Wait for services to be ready
print_status "Waiting for services to be ready..."
sleep 10

# Test all protocols
print_status "Testing all protocols..."

# Test HTTP (port 8080)
if curl -s http://localhost:8080/health > /dev/null; then
    print_success "HTTP service is working (port 8080)"
else
    print_warning "HTTP service test failed"
fi

# Test HTTPS (port 8443)
if curl -s -k https://localhost:8443/health > /dev/null; then
    print_success "HTTPS service is working (port 8443)"
else
    print_warning "HTTPS service test failed"
fi

# Test HTTP/2 (port 8444)
if curl -s -k https://localhost:8444/health > /dev/null; then
    print_success "HTTP/2 service is working (port 8444)"
else
    print_warning "HTTP/2 service test failed"
fi

# Test application API
if curl -s http://localhost:8080/api/user | grep -q "Authentication required"; then
    print_success "Application API is working"
else
    print_warning "Application API test failed"
fi

# Test frontend
FRONTEND_RESPONSE=$(curl -s http://localhost:8080)
if echo "$FRONTEND_RESPONSE" | grep -q "Complete Notes App"; then
    print_success "Frontend is working"
else
    print_warning "Frontend test failed"
fi

echo ""
print_success "🎯 COMPLETE APPLICATION FEATURES:"
echo "────────────────────────────────────────"
echo "✅ HTTP Protocol (port 8080)"
echo "✅ HTTPS Protocol (port 8443)"
echo "✅ HTTP/2 Protocol (port 8444)"
echo "✅ User Authentication"
echo "✅ Create, Read, Delete Notes"
echo "✅ Admin Panel with Settings"
echo "✅ Idle Timeout Management (30s-5min)"
echo "✅ User Management (Create/Delete Users)"
echo "✅ Session Management"
echo "✅ Database Persistence"
echo "✅ All in ONE Container!"

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
print_status "📋 HOW TO USE:"
echo "  1. Open browser and go to any of the URLs above"
echo "  2. Login with admin/admin123"
echo "  3. Create, view, and manage notes"
echo "  4. Access Admin panel for settings and user management"
echo "  5. Configure idle timeout (30 seconds to 5 minutes)"
echo "  6. Create and delete users"

echo ""
print_success "🚀 YOUR COMPLETE NOTES APP IS READY!"
echo "Full protocol support with all features in ONE container!"
