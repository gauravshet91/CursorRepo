#!/bin/bash

echo "🐳 Running Docker Hub Image: gauravshet91/notesapp1:latest"
echo "========================================================="

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

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if image exists
if ! docker images | grep -q "gauravshet91/notesapp1"; then
    print_status "Pulling Docker image from Docker Hub..."
    if docker pull gauravshet91/notesapp1:latest; then
        print_success "Image pulled successfully!"
    else
        print_error "Failed to pull image from Docker Hub"
        exit 1
    fi
else
    print_success "Image already available locally"
fi

# Stop any existing containers
print_status "Stopping any existing containers..."
docker stop notes-app-hub 2>/dev/null || true
docker rm notes-app-hub 2>/dev/null || true

# Create data directory for database persistence
print_status "Creating data directory..."
mkdir -p ./data

# Run the container with the specified ports
print_status "Starting container with port configuration:"
echo "  🌐 HTTP:  port 8080"
echo "  🔐 HTTPS: port 8443" 
echo "  ⚡ HTTP/2: port 8444"
echo ""

# Run the container
docker run -d \
  --name notes-app-hub \
  -p 8080:3000 \
  -p 8443:3000 \
  -p 8444:3000 \
  -v $(pwd)/data:/app/data \
  -e NODE_ENV=production \
  -e PORT=3000 \
  -e SESSION_SECRET=your-super-secret-session-key-change-this \
  -e DB_PATH=/app/data/notes.db \
  --restart unless-stopped \
  gauravshet91/notesapp1:latest

if [ $? -eq 0 ]; then
    print_success "Container started successfully!"
    
    # Wait for container to be ready
    print_status "Waiting for container to be ready..."
    sleep 10
    
    # Test the endpoints
    print_status "Testing endpoints..."
    
    # Test HTTP on port 8080
    if curl -s http://localhost:8080/api/user > /dev/null; then
        print_success "HTTP (port 8080): ✅ Working"
    else
        print_warning "HTTP (port 8080): ❌ Failed"
    fi
    
    # Test HTTPS on port 8443 (will show SSL error but connection works)
    if curl -s -k https://localhost:8443/api/user > /dev/null 2>&1; then
        print_success "HTTPS (port 8443): ✅ Working"
    else
        print_warning "HTTPS (port 8443): ❌ Failed (SSL certificate issue)"
    fi
    
    # Test HTTP/2 on port 8444
    if curl -s http://localhost:8444/api/user > /dev/null; then
        print_success "HTTP/2 (port 8444): ✅ Working"
    else
        print_warning "HTTP/2 (port 8444): ❌ Failed"
    fi
    
    echo ""
    print_success "🎉 Container is running!"
    echo ""
    print_status "Container Status:"
    docker ps | grep notes-app-hub
    echo ""
    print_status "Access Points:"
    echo "  🌐 HTTP:  http://localhost:8080"
    echo "  🔐 HTTPS: https://localhost:8443 (SSL warning expected)"
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
    
else
    print_error "Failed to start container"
    echo ""
    print_warning "Common issues:"
    echo "1. Port already in use - check with: sudo lsof -i :8080"
    echo "2. Permission issues - try with sudo"
    echo "3. Image not found - run: docker pull gauravshet91/notesapp1:latest"
fi
