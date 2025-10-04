#!/bin/bash

echo "🐳 Building Notes Application Docker Image"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Clean up any existing containers
print_status "Cleaning up existing containers..."
docker compose down --remove-orphans 2>/dev/null || true

# Build the Docker image
print_status "Building Docker image..."
if docker compose build --no-cache; then
    print_success "Docker image built successfully!"
else
    print_error "Failed to build Docker image"
    exit 1
fi

# Start the services
print_status "Starting services..."
if docker compose up -d; then
    print_success "Services started successfully!"
else
    print_error "Failed to start services"
    exit 1
fi

# Wait for services to be ready
print_status "Waiting for services to be ready..."
sleep 10

# Test the services
print_status "Testing services..."

# Test HTTP
if curl -s http://localhost:8080/health > /dev/null; then
    print_success "HTTP service is working (port 8080)"
else
    print_warning "HTTP service test failed"
fi

# Test HTTPS
if curl -s -k https://localhost:8443/health > /dev/null; then
    print_success "HTTPS service is working (port 8443)"
else
    print_warning "HTTPS service test failed"
fi

# Test application API
if curl -s http://localhost:8080/api/user | grep -q "Authentication required"; then
    print_success "Application API is working"
else
    print_warning "Application API test failed"
fi

# Show container status
print_status "Container status:"
docker compose ps

echo ""
print_success "🐳 Docker setup complete!"
echo ""
echo "📋 Access Points:"
echo "  🌐 HTTP:  http://localhost:8080"
echo "  🔐 HTTPS: https://localhost:8443"
echo "  📱 App:   http://localhost:8080 (or https://localhost:8443)"
echo ""
echo "🔧 Management Commands:"
echo "  View logs:    docker compose logs -f"
echo "  Stop:         docker compose down"
echo "  Restart:      docker compose restart"
echo "  Rebuild:      docker compose up --build -d"
echo ""
echo "👤 Default Login:"
echo "  Username: admin"
echo "  Password: admin123"
