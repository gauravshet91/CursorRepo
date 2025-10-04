# 🐳 Notes Application - Docker Setup

A secure notes application with full protocol support (HTTP/1.1, HTTPS, HTTP/2) running in Docker containers.

## 🚀 Quick Start

### Option 1: Automated Setup
```bash
./build-docker.sh
```

### Option 2: Manual Setup
```bash
# Build and start services
docker compose up --build -d

# Check status
docker compose ps

# View logs
docker compose logs -f
```

## 📋 Access Points

| Protocol | URL | Port | Description |
|----------|-----|------|-------------|
| HTTP/1.1 | http://localhost:80 | 80 | nginx reverse proxy |
| HTTPS | https://localhost:443 | 443 | SSL/TLS encrypted |
| HTTP/2 | https://localhost:443 | 443 | HTTP/2 over TLS |

## 🔐 Default Login

- **Username**: `admin`
- **Password**: `admin123`

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Client        │    │   nginx         │    │   notes-app     │
│   Browser       │───▶│   Reverse Proxy │───▶│   Node.js App   │
│                 │    │   Port 80/443   │    │   Port 3000     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🐳 Docker Services

### notes-app
- **Image**: Custom Node.js application
- **Port**: 3000 (internal)
- **Features**: 
  - Express.js server
  - SQLite database
  - Session management
  - Rate limiting
  - Security headers

### nginx
- **Image**: nginx:alpine
- **Ports**: 80, 443
- **Features**:
  - Reverse proxy
  - SSL termination
  - HTTP/2 support
  - Rate limiting
  - Gzip compression

## 🔧 Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `NODE_ENV` | production | Node.js environment |
| `PORT` | 3000 | Application port |
| `SESSION_SECRET` | your-super-secret-session-key-change-this | Session encryption key |
| `DB_PATH` | /app/data/notes.db | Database file path |

### Volumes

| Volume | Mount Point | Description |
|--------|-------------|-------------|
| `notes_data` | /app/data | Database and persistent data |

### Networks

| Network | Type | Description |
|---------|------|-------------|
| `notes-network` | bridge | Internal communication |

## 🛠️ Management Commands

### Container Management
```bash
# Start services
docker compose up -d

# Stop services
docker compose down

# Restart services
docker compose restart

# View logs
docker compose logs -f

# View specific service logs
docker compose logs -f notes-app
docker compose logs -f nginx
```

### Container Status
```bash
# Check status
docker compose ps

# Check health
docker compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
```

### Rebuilding
```bash
# Rebuild and restart
docker compose up --build -d

# Force rebuild (no cache)
docker compose build --no-cache
docker compose up -d
```

## 🔍 Troubleshooting

### Common Issues

1. **Port already in use**
   ```bash
   # Check what's using the port
   sudo lsof -i :80
   sudo lsof -i :443
   
   # Kill the process
   sudo kill -9 <PID>
   ```

2. **Container won't start**
   ```bash
   # Check logs
   docker compose logs notes-app
   docker compose logs nginx
   
   # Check container status
   docker compose ps
   ```

3. **Database issues**
   ```bash
   # Check volume
   docker volume ls
   docker volume inspect cursor_notes_data
   
   # Reset database
   docker compose down -v
   docker compose up -d
   ```

4. **SSL certificate issues**
   ```bash
   # Check SSL certificates
   ls -la ssl/
   
   # Regenerate certificates
   cd ssl/
   openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
   ```

### Health Checks

```bash
# Test HTTP
curl http://localhost:80/health

# Test HTTPS
curl -k https://localhost:443/health

# Test API
curl http://localhost:80/api/user

# Test with authentication
curl -X POST http://localhost:80/api/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

## 🔒 Security Features

- **SSL/TLS Encryption**: HTTPS with self-signed certificates
- **HTTP/2 Support**: Modern protocol with multiplexing
- **Rate Limiting**: API and login rate limiting
- **Security Headers**: HSTS, CSP, X-Frame-Options, etc.
- **Non-root User**: Container runs as non-privileged user
- **Input Validation**: SQL injection and XSS protection

## 📊 Performance Features

- **HTTP/2 Multiplexing**: Multiple requests over single connection
- **Gzip Compression**: Reduced bandwidth usage
- **Connection Pooling**: Efficient database connections
- **Caching**: Static file caching
- **Health Checks**: Automatic container health monitoring

## 🚀 Production Deployment

### Environment Setup
1. Change default passwords
2. Use proper SSL certificates
3. Set strong session secrets
4. Configure proper domain names
5. Set up monitoring and logging

### Scaling
```bash
# Scale the application
docker compose up --scale notes-app=3 -d

# Use load balancer for multiple instances
```

### Backup
```bash
# Backup database
docker run --rm -v cursor_notes_data:/data -v $(pwd):/backup alpine tar czf /backup/notes-backup.tar.gz -C /data .
```

## 📝 Development

### Local Development
```bash
# Run in development mode
NODE_ENV=development docker compose up -d

# Watch logs
docker compose logs -f notes-app
```

### Debugging
```bash
# Access container shell
docker compose exec notes-app sh

# Check nginx configuration
docker compose exec nginx nginx -t

# View nginx access logs
docker compose exec nginx tail -f /var/log/nginx/access.log
```

## 📄 License

MIT License - see LICENSE file for details.
