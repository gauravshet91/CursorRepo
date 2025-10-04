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

echo "🐳 DOCKER HUB - PUSH VERSION 1.0"
echo "================================="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker first."
    exit 1
fi

# Tag the current working image
print_status "Tagging current image as version 1.0..."
docker tag cursor-notes-app-simple gauravshet91/notesapp1:v1.0
docker tag cursor-notes-app-simple gauravshet91/notesapp1:latest

if [ $? -eq 0 ]; then
    print_success "Images tagged successfully"
else
    print_error "Failed to tag images"
    exit 1
fi

# Show the tagged images
print_status "Tagged images:"
docker images | grep gauravshet91/notesapp1

echo ""
print_status "To push to Docker Hub, you need to:"
echo "1. Login to Docker Hub: docker login"
echo "2. Enter your Docker Hub credentials"
echo "3. Run: docker push gauravshet91/notesapp1:v1.0"
echo "4. Run: docker push gauravshet91/notesapp1:latest"

echo ""
print_status "Or run this script with your credentials:"
echo "./push-to-dockerhub.sh <username> <password>"

# If credentials provided, try to login and push
if [ $# -eq 2 ]; then
    USERNAME=$1
    PASSWORD=$2
    
    print_status "Attempting to login to Docker Hub..."
    echo "$PASSWORD" | docker login --username "$USERNAME" --password-stdin
    
    if [ $? -eq 0 ]; then
        print_success "Logged in to Docker Hub successfully"
        
        print_status "Pushing version 1.0..."
        docker push gauravshet91/notesapp1:v1.0
        
        if [ $? -eq 0 ]; then
            print_success "✅ Version 1.0 pushed successfully!"
        else
            print_error "❌ Failed to push version 1.0"
        fi
        
        print_status "Pushing latest version..."
        docker push gauravshet91/notesapp1:latest
        
        if [ $? -eq 0 ]; then
            print_success "✅ Latest version pushed successfully!"
        else
            print_error "❌ Failed to push latest version"
        fi
        
        echo ""
        print_success "🎉 VERSION 1.0 UPLOADED TO DOCKER HUB!"
        echo "Repository: gauravshet91/notesapp1"
        echo "Tags: v1.0, latest"
        echo ""
        print_status "To pull and run:"
        echo "docker pull gauravshet91/notesapp1:v1.0"
        echo "docker run -p 8080:8080 -p 8443:8443 -p 8444:8444 gauravshet91/notesapp1:v1.0"
        
    else
        print_error "Failed to login to Docker Hub"
        exit 1
    fi
else
    print_warning "No credentials provided. Please login manually or provide credentials."
fi