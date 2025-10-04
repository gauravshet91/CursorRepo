# 🐳 Docker Hub Deployment Guide

## 📦 Published Image

**Repository**: `gauravshet91/notesapp1:latest`  
**Size**: ~142MB  
**Base**: Node.js 18 Alpine Linux  
**Architecture**: Multi-stage optimized build

## 🚀 Quick Deployment

### Option 1: Direct Docker Run
```bash
# Pull and run the image
docker pull gauravshet91/notesapp1:latest
docker run -p 3000:3000 gauravshet91/notesapp1:latest
```

### Option 2: Docker Compose (Recommended)
```bash
# Use the pre-configured compose file
docker compose -f docker-compose-hub.yml up -d
```

### Option 3: Custom Docker Compose
```yaml
version: '3.8'
services:
  notes-app:
    image: gauravshet91/notesapp1:latest
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - PORT=3000
      - SESSION_SECRET=your-secret-key
      - DB_PATH=/app/data/notes.db
    volumes:
      - notes_data:/app/data
    restart: unless-stopped

volumes:
  notes_data:
```

## 🔧 Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `NODE_ENV` | production | Node.js environment |
| `PORT` | 3000 | Application port |
| `SESSION_SECRET` | your-super-secret-session-key-change-this | Session encryption key |
| `DB_PATH` | /app/data/notes.db | Database file path |

## 🌐 Access Points

After deployment, access the application at:
- **HTTP**: `http://localhost:3000` (direct)
- **HTTP**: `http://localhost:80` (with nginx proxy)
- **HTTPS**: `https://localhost:443` (with SSL)

## 👤 Default Login

- **Username**: `admin`
- **Password**: `admin123`

## 📋 Features

### ✅ **Application Features**
- Secure notes management
- User authentication
- Session management
- SQLite database
- RESTful API

### ✅ **Docker Features**
- Multi-stage optimized build
- Non-root user execution
- Health checks
- Volume persistence
- Environment configuration

### ✅ **Security Features**
- SSL/TLS support
- HTTP/2 support
- Security headers
- Rate limiting
- Input validation

## 🛠️ Management Commands

### **Basic Operations**
```bash
# Pull latest image
docker pull gauravshet91/notesapp1:latest

# Run container
docker run -d -p 3000:3000 --name notes-app gauravshet91/notesapp1:latest

# Stop container
docker stop notes-app

# Remove container
docker rm notes-app
```

### **Docker Compose Operations**
```bash
# Start services
docker compose -f docker-compose-hub.yml up -d

# Stop services
docker compose -f docker-compose-hub.yml down

# View logs
docker compose -f docker-compose-hub.yml logs -f

# Restart services
docker compose -f docker-compose-hub.yml restart
```

### **Data Management**
```bash
# Backup database
docker run --rm -v cursor_notes_data:/data -v $(pwd):/backup alpine tar czf /backup/notes-backup.tar.gz -C /data .

# Restore database
docker run --rm -v cursor_notes_data:/data -v $(pwd):/backup alpine tar xzf /backup/notes-backup.tar.gz -C /data
```

## 🔍 Troubleshooting

### **Common Issues**

1. **Port already in use**
   ```bash
   # Check what's using the port
   sudo lsof -i :3000
   
   # Use different port
   docker run -p 3001:3000 gauravshet91/notesapp1:latest
   ```

2. **Permission denied**
   ```bash
   # Check Docker permissions
   sudo usermod -aG docker $USER
   # Logout and login again
   ```

3. **Container won't start**
   ```bash
   # Check logs
   docker logs notes-app
   
   # Check container status
   docker ps -a
   ```

4. **Database issues**
   ```bash
   # Check volume
   docker volume ls
   docker volume inspect cursor_notes_data
   ```

### **Health Checks**
```bash
# Test application
curl http://localhost:3000/api/user

# Test with authentication
curl -X POST http://localhost:3000/api/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

## 📊 Performance

- **Image Size**: ~142MB (optimized)
- **Startup Time**: ~5-10 seconds
- **Memory Usage**: ~50-100MB
- **CPU Usage**: Minimal (idle)

## 🔄 Updates

### **Pull Latest Version**
```bash
# Pull latest image
docker pull gauravshet91/notesapp1:latest

# Restart with new image
docker compose -f docker-compose-hub.yml down
docker compose -f docker-compose-hub.yml up -d
```

### **Version Management**
```bash
# Use specific version
docker run gauravshet91/notesapp1:v1.0.0

# List available tags
docker search gauravshet91/notesapp1
```

## 📚 Documentation

- **Docker Hub**: https://hub.docker.com/r/gauravshet91/notesapp1
- **GitHub**: [Repository URL]
- **Documentation**: [Docs URL]

## 🆘 Support

For issues and support:
1. Check Docker logs: `docker logs notes-app`
2. Verify environment variables
3. Check network connectivity
4. Review Docker Hub documentation

## 🎯 Production Deployment

### **Recommended Setup**
1. Use Docker Compose for orchestration
2. Set strong session secrets
3. Configure proper domain names
4. Set up SSL certificates
5. Implement monitoring and logging
6. Configure backup strategies

### **Scaling**
```bash
# Scale the application
docker compose -f docker-compose-hub.yml up --scale notes-app=3 -d
```

---

**🎉 Your Notes Application is now available on Docker Hub!**

**Repository**: `gauravshet91/notesapp1:latest`  
**Access**: https://hub.docker.com/r/gauravshet91/notesapp1
