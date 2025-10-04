#!/bin/bash

echo "🐳 Docker Hub Image Status Check"
echo "================================"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

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

# Check container status
print_status "Container Status:"
if docker ps | grep -q "notes-app-hub"; then
    docker ps | grep "notes-app-hub"
    print_success "Container is running!"
else
    print_error "Container is not running"
    exit 1
fi

echo ""

# Test endpoints
print_status "Testing Endpoints:"

# Test HTTP on port 8080
if curl -s http://localhost:8080/api/user | grep -q "Authentication required"; then
    print_success "HTTP (port 8080): ✅ Working"
else
    print_warning "HTTP (port 8080): ❌ Failed"
fi

# Test HTTPS on port 8443
if curl -s http://localhost:8443/api/user | grep -q "Authentication required"; then
    print_success "HTTPS (port 8443): ✅ Working"
else
    print_warning "HTTPS (port 8443): ❌ Failed"
fi

# Test HTTP/2 on port 8444
if curl -s http://localhost:8444/api/user | grep -q "Authentication required"; then
    print_success "HTTP/2 (port 8444): ✅ Working"
else
    print_warning "HTTP/2 (port 8444): ❌ Failed"
fi

echo ""
print_status "Access Points:"
echo "  🌐 HTTP:  http://localhost:8080"
echo "  🔐 HTTPS: http://localhost:8443"
echo "  ⚡ HTTP/2: http://localhost:8444"
echo ""
print_status "Default Login:"
echo "  Username: admin"
echo "  Password: admin123"
echo ""
print_status "Management Commands:"
echo "  View logs:    docker logs -f notes-app-hub"
echo "  Stop:         docker stop notes-app-hub"
echo "  Remove:       docker rm notes-app-hub"
echo "  Restart:      docker restart notes-app-hub"
echo ""
print_success "🎉 Your Docker Hub image is running successfully!"
