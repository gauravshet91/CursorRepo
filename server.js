const express = require('express');
const session = require('express-session');
const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const bcrypt = require('bcryptjs');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors({
    origin: true,
    credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Session configuration
app.use(session({
    secret: process.env.SESSION_SECRET || 'your-secret-key-change-in-production',
    resave: false,
    saveUninitialized: false,
    cookie: {
        secure: false, // Set to false for development
        httpOnly: true,
        maxAge: 7 * 24 * 60 * 60 * 1000, // 7 days (1 week)
        sameSite: 'lax'
    },
    name: 'notesapp.sid' // Custom session name
}));

// Database initialization
const dbPath = process.env.DB_PATH || 'notes.db';
const db = new sqlite3.Database(dbPath);

// Initialize database tables
db.serialize(() => {
    // Users table
    db.run(`CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )`);

    // Notes table
    db.run(`CREATE TABLE IF NOT EXISTS notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        user_id INTEGER NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id)
    )`);

    // Settings table for idle timeout
    db.run(`CREATE TABLE IF NOT EXISTS settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        setting_key TEXT UNIQUE NOT NULL,
        setting_value TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )`, (err) => {
        if (err) {
            console.error('Error creating settings table:', err);
        } else {
            console.log('Settings table created/verified');
        }
    });
});

// Wait for tables to be created, then insert default data
setTimeout(() => {
    // Insert default admin user if not exists
    db.get("SELECT COUNT(*) as count FROM users WHERE username = 'admin'", (err, row) => {
        if (err) {
            console.error('Error checking admin user:', err);
        } else if (row && row.count === 0) {
            const hashedPassword = bcrypt.hashSync('admin123', 10);
            db.run("INSERT INTO users (username, password) VALUES (?, ?)", ['admin', hashedPassword], (err) => {
                if (err) {
                    console.error('Error creating admin user:', err);
                } else {
                    console.log('Admin user created successfully');
                }
            });
        } else {
            console.log('Admin user already exists');
        }
    });

    // Insert default settings
    db.get("SELECT COUNT(*) as count FROM settings WHERE setting_key = 'idle_timeout'", (err, row) => {
        if (err) {
            console.error('Error checking settings:', err);
        } else if (row && row.count === 0) {
            db.run("INSERT INTO settings (setting_key, setting_value) VALUES (?, ?)", ['idle_timeout', '300'], (err) => {
                if (err) {
                    console.error('Error creating default settings:', err);
                } else {
                    console.log('Default settings created successfully');
                }
            });
        } else {
            console.log('Default settings already exist');
        }
    });
}, 1000);

// Serve static files (frontend)
app.use(express.static('public'));

// Authentication middleware
const requireAuth = (req, res, next) => {
    if (req.session && req.session.userId) {
        next();
    } else {
        res.status(401).json({ error: 'Authentication required' });
    }
};

// Admin middleware
const requireAdmin = (req, res, next) => {
    if (req.session && req.session.userId && req.session.isAdmin) {
        next();
    } else {
        res.status(403).json({ error: 'Admin access required' });
    }
};

// API Routes

// Login
app.post('/api/login', (req, res) => {
    const { username, password } = req.body;

    if (!username || !password) {
        return res.status(400).json({ error: 'Username and password required' });
    }

    db.get("SELECT * FROM users WHERE username = ?", [username], (err, user) => {
        if (err) {
            return res.status(500).json({ error: 'Database error' });
        }

        if (!user || !bcrypt.compareSync(password, user.password)) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }

        req.session.userId = user.id;
        req.session.username = user.username;
        req.session.isAdmin = user.username === 'admin';

        res.json({ 
            success: true, 
            user: { 
                id: user.id, 
                username: user.username,
                isAdmin: user.username === 'admin'
            } 
        });
    });
});

// Logout
app.post('/api/logout', (req, res) => {
    req.session.destroy((err) => {
        if (err) {
            return res.status(500).json({ error: 'Could not log out' });
        }
        res.json({ success: true });
    });
});

// Get current user
app.get('/api/user', (req, res) => {
    if (req.session && req.session.userId) {
        res.json({ 
            user: { 
                id: req.session.userId, 
                username: req.session.username,
                isAdmin: req.session.isAdmin
            } 
        });
    } else {
        res.status(401).json({ error: 'Authentication required' });
    }
});

// Get settings (idle timeout)
app.get('/api/settings', requireAuth, (req, res) => {
    db.get("SELECT setting_value FROM settings WHERE setting_key = 'idle_timeout'", (err, row) => {
        if (err) {
            return res.status(500).json({ error: 'Database error' });
        }
        res.json({ idle_timeout: parseInt(row.setting_value) });
    });
});

// Update settings (admin only)
app.put('/api/settings', requireAdmin, (req, res) => {
    const { idle_timeout } = req.body;

    if (!idle_timeout || idle_timeout < 30 || idle_timeout > 300) {
        return res.status(400).json({ error: 'Idle timeout must be between 30 and 300 seconds' });
    }

    db.run("UPDATE settings SET setting_value = ?, updated_at = CURRENT_TIMESTAMP WHERE setting_key = 'idle_timeout'", 
        [idle_timeout.toString()], (err) => {
        if (err) {
            return res.status(500).json({ error: 'Database error' });
        }
        res.json({ success: true, idle_timeout: parseInt(idle_timeout) });
    });
});

// Get all users (admin only)
app.get('/api/users', requireAdmin, (req, res) => {
    db.all("SELECT id, username, created_at FROM users ORDER BY created_at DESC", (err, users) => {
        if (err) {
            return res.status(500).json({ error: 'Database error' });
        }
        res.json({ users });
    });
});

// Create user (admin only)
app.post('/api/users', requireAdmin, (req, res) => {
    const { username, password } = req.body;

    if (!username || !password) {
        return res.status(400).json({ error: 'Username and password required' });
    }

    if (username.length < 3) {
        return res.status(400).json({ error: 'Username must be at least 3 characters' });
    }

    if (password.length < 6) {
        return res.status(400).json({ error: 'Password must be at least 6 characters' });
    }

    const hashedPassword = bcrypt.hashSync(password, 10);

    db.run("INSERT INTO users (username, password) VALUES (?, ?)", [username, hashedPassword], function(err) {
        if (err) {
            if (err.message.includes('UNIQUE constraint failed')) {
                return res.status(400).json({ error: 'Username already exists' });
            }
            return res.status(500).json({ error: 'Database error' });
        }
        res.json({ success: true, userId: this.lastID });
    });
});

// Delete user (admin only)
app.delete('/api/users/:id', requireAdmin, (req, res) => {
    const userId = req.params.id;

    if (userId == req.session.userId) {
        return res.status(400).json({ error: 'Cannot delete your own account' });
    }

    db.run("DELETE FROM users WHERE id = ?", [userId], function(err) {
        if (err) {
            return res.status(500).json({ error: 'Database error' });
        }
        if (this.changes === 0) {
            return res.status(404).json({ error: 'User not found' });
        }
        res.json({ success: true });
    });
});

// Get notes
app.get('/api/notes', requireAuth, (req, res) => {
    db.all("SELECT * FROM notes WHERE user_id = ? ORDER BY updated_at DESC", [req.session.userId], (err, notes) => {
        if (err) {
            return res.status(500).json({ error: 'Database error' });
        }
        res.json({ notes });
    });
});

// Create note
app.post('/api/notes', requireAuth, (req, res) => {
    const { title, content } = req.body;

    if (!title || !content) {
        return res.status(400).json({ error: 'Title and content required' });
    }

    db.run("INSERT INTO notes (title, content, user_id) VALUES (?, ?, ?)", 
        [title, content, req.session.userId], function(err) {
        if (err) {
            return res.status(500).json({ error: 'Database error' });
        }
        res.json({ success: true, noteId: this.lastID });
    });
});

// Update note
app.put('/api/notes/:id', requireAuth, (req, res) => {
    const noteId = req.params.id;
    const { title, content } = req.body;

    if (!title || !content) {
        return res.status(400).json({ error: 'Title and content required' });
    }

    db.run("UPDATE notes SET title = ?, content = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ? AND user_id = ?", 
        [title, content, noteId, req.session.userId], function(err) {
        if (err) {
            return res.status(500).json({ error: 'Database error' });
        }
        if (this.changes === 0) {
            return res.status(404).json({ error: 'Note not found' });
        }
        res.json({ success: true });
    });
});

// Delete note
app.delete('/api/notes/:id', requireAuth, (req, res) => {
    const noteId = req.params.id;

    db.run("DELETE FROM notes WHERE id = ? AND user_id = ?", [noteId, req.session.userId], function(err) {
        if (err) {
            return res.status(500).json({ error: 'Database error' });
        }
        if (this.changes === 0) {
            return res.status(404).json({ error: 'Note not found' });
        }
        res.json({ success: true });
    });
});

// Catch-all for SPA
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 Complete Notes App server running on port ${PORT}`);
    console.log(`📱 Frontend: http://localhost:${PORT}`);
    console.log(`🔐 HTTPS: https://localhost:8443`);
    console.log(`⚡ HTTP/2: https://localhost:8444`);
    console.log(`👤 Default Admin: admin / admin123`);
});
