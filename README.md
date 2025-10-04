# Complete Notes App - Version 1.2

## 🎉 **Full-Stack Notes Application with Multi-Protocol Support**

A complete, production-ready notes application with user management, admin controls, and support for HTTP, HTTPS, and HTTP/2 protocols - all in a single Docker container.

## ✨ **Features**

### 🔐 **Authentication & Security**
- User authentication with secure password hashing (bcryptjs)
- Session management with configurable timeouts
- Admin panel with full user management
- Secure SSL/TLS support for HTTPS and HTTP/2

### 📝 **Notes Management**
- Create, read, update, and delete notes
- User-specific note isolation
- Real-time note management interface
- Persistent storage with SQLite database

### ⚙️ **Admin Panel**
- **User Management**: Create and delete users
- **Idle Timeout Configuration**: Set session timeout (30 seconds to 5 minutes)
- **Settings Management**: Configure application behavior
- **Real-time Controls**: Immediate effect of changes

### 🌐 **Multi-Protocol Support**
- **HTTP**: Standard web protocol (port 8080)
- **HTTPS**: Secure encrypted connection (port 8443)
- **HTTP/2**: Modern high-performance protocol (port 8444)

## 🐳 **Docker Hub Repository**

**Repository:** `gauravshet91/notesapp2`
**Latest Version:** `v1.2`
**Tags:** `v1.2`, `latest`

## 🚀 **Quick Start**

### **Option 1: Deploy from Source**
```bash
# Clone the repository
git clone <repository-url>
cd notesapp2

# Deploy the application
./deploy.sh
```

### **Option 2: Pull and Run**
```bash
# Pull the latest version
docker pull gauravshet91/notesapp2:v1.2

# Run the container
docker run -d --name notes-app \
  -p 8080:8080 \
  -p 8443:8443 \
  -p 8444:8444 \
  -v notes_data:/app/data \
  gauravshet91/notesapp2:v1.2
```

### **Access the Application**
- **HTTP:** http://localhost:8080
- **HTTPS:** https://localhost:8443
- **HTTP/2:** https://localhost:8444

### **Default Login**
- **Username:** `admin`
- **Password:** `admin123`

## 📋 **Usage Guide**

### **1. Login**
1. Open any of the URLs above in your browser
2. Login with admin/admin123
3. Access the full application interface

### **2. Create Notes**
1. Click "Create New Note" button
2. Enter title and content
3. Save the note
4. View, edit, or delete notes as needed

### **3. Admin Functions**
1. Click the "Admin" tab
2. **Settings Tab:**
   - Configure idle timeout (30 seconds to 5 minutes)
   - Save settings to apply changes
3. **Users Tab:**
   - Create new users with username/password
   - Delete existing users (except admin)
   - Manage user access

### **4. User Management**
- **Create Users:** Admin can create new users
- **Delete Users:** Remove users (admin account protected)
- **User Isolation:** Each user sees only their own notes

## 🔧 **Technical Specifications**

### **Container Architecture**
- **Base Image:** node:18-alpine
- **Web Server:** nginx (reverse proxy)
- **Application:** Node.js Express
- **Database:** SQLite3 with volume persistence
- **SSL:** Self-signed certificates for HTTPS/HTTP2

### **Port Configuration**
- **8080:** HTTP traffic
- **8443:** HTTPS traffic  
- **8444:** HTTP/2 traffic

### **Environment Variables**
```bash
NODE_ENV=production
PORT=3000
DB_PATH=/app/data/notes.db
SESSION_SECRET=your-super-secret-session-key-change-this
```

### **Volume Mounting**
- **Database:** `/app/data` → `notes_data` volume
- **Persistence:** Notes and users persist across container restarts

## 📊 **Performance Specifications**

- **Container Size:** ~151MB
- **Startup Time:** ~10-15 seconds
- **Memory Usage:** ~50-100MB
- **CPU Usage:** Low
- **Database:** SQLite with automatic schema management

## 🛠️ **Development & Customization**

### **Local Development**
```bash
# Clone the repository
git clone <repository-url>
cd notesapp2

# Deploy locally
./deploy.sh

# Or build manually
docker build -t notesapp2:local .
docker compose up -d
```

### **Custom Configuration**
- **Idle Timeout:** 30 seconds to 5 minutes (configurable via admin panel)
- **Session Duration:** 7 days (configurable in server.js)
- **Database Path:** `/app/data/notes.db` (configurable via environment)

## 🔒 **Security Features**

### **Authentication**
- Password hashing with bcryptjs
- Session-based authentication
- Admin role separation
- User isolation

### **SSL/TLS**
- Self-signed certificates for HTTPS/HTTP2
- TLS 1.2 and 1.3 support
- Security headers (HSTS, X-Frame-Options, etc.)

### **Data Protection**
- SQL injection prevention
- XSS protection
- CSRF protection
- Rate limiting on API endpoints

## 📈 **Monitoring & Health Checks**

### **Health Check Endpoints**
- **HTTP:** http://localhost:8080/health
- **HTTPS:** https://localhost:8443/health
- **HTTP/2:** https://localhost:8444/health

### **Container Health**
```bash
# Check container status
docker ps

# View logs
docker logs notes-app

# Check health
docker inspect notes-app | grep Health
```

## 🚨 **Troubleshooting**

### **Common Issues**

**1. Port Already in Use**
```bash
# Stop conflicting containers
docker stop $(docker ps -q)

# Or use different ports
docker run -p 8081:8080 -p 8445:8443 -p 8446:8444 ...
```

**2. Database Issues**
```bash
# Reset database
docker volume rm notes_data
docker run ... # Restart container
```

**3. SSL Certificate Issues**
```bash
# Accept self-signed certificates in browser
# Or use HTTP (port 8080) for testing
```

### **Logs and Debugging**
```bash
# View application logs
docker logs notes-app

# Check nginx logs
docker exec notes-app cat /var/log/nginx/error.log

# Test API endpoints
curl http://localhost:8080/api/user
```

## 📚 **API Documentation**

### **Authentication Endpoints**
- `POST /api/login` - User login
- `POST /api/logout` - User logout
- `GET /api/user` - Get current user

### **Notes Endpoints**
- `GET /api/notes` - Get user's notes
- `POST /api/notes` - Create new note
- `PUT /api/notes/:id` - Update note
- `DELETE /api/notes/:id` - Delete note

### **Admin Endpoints**
- `GET /api/settings` - Get application settings
- `PUT /api/settings` - Update settings (admin only)
- `GET /api/users` - Get all users (admin only)
- `POST /api/users` - Create user (admin only)
- `DELETE /api/users/:id` - Delete user (admin only)

## 🏷️ **Version History**

### **Version 1.2 (Current)**
- ✅ Fixed database schema issues
- ✅ User creation working
- ✅ Idle timeout settings working
- ✅ All admin functions operational
- ✅ Multi-protocol support
- ✅ Complete feature set

### **Version 1.1**
- 🔧 Database initialization improvements
- 🔧 Error handling enhancements

### **Version 1.0**
- 🎉 Initial release
- 🎉 Basic notes functionality
- 🎉 Admin panel
- 🎉 Multi-protocol support

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 **License**

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 **Support**

For issues, questions, or contributions:
- Create an issue in the repository
- Check the troubleshooting section
- Review the API documentation

## 🎯 **Roadmap**

### **Future Enhancements**
- [ ] User roles and permissions
- [ ] Note sharing between users
- [ ] File attachments
- [ ] Note categories and tags
- [ ] Advanced search functionality
- [ ] Export/import features
- [ ] Mobile-responsive improvements
- [ ] Real-time collaboration

---

**🎉 Your Complete Notes App is ready for production use!**

**Repository:** `gauravshet91/notesapp2`  
**Latest Version:** `v1.2`  
**Status:** ✅ Production Ready