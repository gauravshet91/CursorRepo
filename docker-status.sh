#!/bin/bash

echo "🐳 Notes Application - Docker Status"
echo "===================================="

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

# Check Docker status
if ! docker info > /dev/null 2>&1; then
    print_warning "Docker is not running"
    exit 1
fi

# Container status
print_status "Container Status:"
docker compose ps

echo ""

# Test endpoints
print_status "Testing Endpoints:"

# Test HTTP
if curl -s http://localhost:8080/health > /dev/null; then
    print_success "HTTP (port 8080): ✅ Working"
else
    print_warning "HTTP (port 8080): ❌ Failed"
fi

# Test HTTPS
if curl -s -k https://localhost:8443/health > /dev/null; then
    print_success "HTTPS (port 8443): ✅ Working"
else
    print_warning "HTTPS (port 8443): ❌ Failed"
fi

# Test API
if curl -s http://localhost:8080/api/user | grep -q "Authentication required"; then
    print_success "API Endpoint: ✅ Working"
else
    print_warning "API Endpoint: ❌ Failed"
fi

echo ""
print_status "Access Points:"
echo "  🌐 HTTP:  http://localhost:8080"
echo "  🔐 HTTPS: https://localhost:8443"
echo "  📱 App:   http://localhost:8080 (or https://localhost:8443)"
echo ""
print_status "Default Login:"
echo "  Username: admin"
echo "  Password: admin123"
echo ""
print_status "Management Commands:"
echo "  View logs:    docker compose logs -f"
echo "  Stop:         docker compose down"
echo "  Restart:      docker compose restart"
echo "  Rebuild:      docker compose up --build -d"
