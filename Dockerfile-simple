# Simple single container with both app and nginx
FROM node:18-alpine

# Install nginx and openssl
RUN apk add --no-cache nginx openssl

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production && npm cache clean --force

# Copy application files
COPY . .

# Create data directory for database
RUN mkdir -p /app/data && \
    chown -R node:node /app/data

# Create nginx directories
RUN mkdir -p /etc/nginx/ssl && \
    mkdir -p /var/log/nginx && \
    mkdir -p /var/lib/nginx

# Generate SSL certificates
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/key.pem \
    -out /etc/nginx/ssl/cert.pem \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Copy nginx configuration
COPY nginx-complete.conf /etc/nginx/nginx.conf

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000
ENV DB_PATH=/app/data/notes.db

# Expose ports
EXPOSE 8080 8443 8444

# Create startup script
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'nginx &' >> /start.sh && \
    echo 'sleep 2' >> /start.sh && \
    echo 'node server.js' >> /start.sh && \
    chmod +x /start.sh

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/api/user', (res) => { process.exit(res.statusCode === 401 ? 0 : 1) })"

# Start both nginx and node
CMD ["/start.sh"]
