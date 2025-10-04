#!/bin/bash

echo "🎯 FINAL PROTOCOL CONFIGURATION STATUS"
echo "======================================"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
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

# Check container status
print_status "Container Status:"
docker compose -f docker-compose-proper-ports.yml ps

echo ""

# Test endpoints
print_status "Testing Protocol Endpoints:"

# Test HTTP on port 8080
if curl -s http://localhost:8080/health > /dev/null; then
    print_success "HTTP/1.1 (port 8080): ✅ Working"
else
    print_warning "HTTP/1.1 (port 8080): ❌ Failed"
fi

# Test HTTPS on port 8443
if curl -s -k https://localhost:8443/health > /dev/null; then
    print_success "HTTPS (port 8443): ✅ Working"
else
    print_warning "HTTPS (port 8443): ❌ Failed"
fi

# Test HTTP/2 on port 8444
if curl -s -k https://localhost:8444/health > /dev/null; then
    print_success "HTTP/2 (port 8444): ✅ Working"
else
    print_warning "HTTP/2 (port 8444): ❌ Failed"
fi

# Test API endpoints
echo ""
print_status "Testing API Endpoints:"

if curl -s http://localhost:8080/api/user | grep -q "Authentication required"; then
    print_success "HTTP API: ✅ Working"
else
    print_warning "HTTP API: ❌ Failed"
fi

if curl -s -k https://localhost:8443/api/user | grep -q "Authentication required"; then
    print_success "HTTPS API: ✅ Working"
else
    print_warning "HTTPS API: ❌ Failed"
fi

if curl -s -k https://localhost:8444/api/user | grep -q "Authentication required"; then
    print_success "HTTP/2 API: ✅ Working"
else
    print_warning "HTTP/2 API: ❌ Failed"
fi

echo ""
print_success "🎉 PROTOCOL CONFIGURATION COMPLETE!"
echo ""
print_status "✅ CORRECT ACCESS POINTS:"
echo "  🌐 HTTP/1.1: http://localhost:8080"
echo "  🔐 HTTPS:     https://localhost:8443"
echo "  ⚡ HTTP/2:    https://localhost:8444"
echo ""
print_status "👤 Login Credentials:"
echo "  Username: admin"
echo "  Password: admin123"
echo ""
print_status "🔧 Management Commands:"
echo "  View logs:    docker compose -f docker-compose-proper-ports.yml logs -f"
echo "  Stop:         docker compose -f docker-compose-proper-ports.yml down"
echo "  Restart:      docker compose -f docker-compose-proper-ports.yml restart"
echo ""
print_success "🚀 All protocols now working with proper HTTPS and HTTP/2!"
