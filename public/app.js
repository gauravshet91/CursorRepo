class NotesApp {
    constructor() {
        this.currentUser = null;
        this.idleTimeout = null;
        this.idleTime = 180000; // 3 minutes default
        this.isIdle = false;
        this.lastActivity = Date.now();
        
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.checkAuthStatus();
        this.startIdleTimer();
        this.setupActivityTracking();
    }

    setupEventListeners() {
        // Login form
        document.getElementById('loginForm').addEventListener('submit', (e) => {
            e.preventDefault();
            this.handleLogin();
        });

        // Logout
        document.getElementById('logoutBtn').addEventListener('click', () => {
            this.handleLogout();
        });

        // Navigation
        document.getElementById('notesTab').addEventListener('click', () => {
            this.showNotesSection();
        });

        document.getElementById('adminTab').addEventListener('click', () => {
            this.showAdminSection();
        });

        // Notes
        document.getElementById('newNoteBtn').addEventListener('click', () => {
            this.openNoteModal();
        });

        document.getElementById('saveNoteBtn').addEventListener('click', () => {
            this.saveNote();
        });

        document.getElementById('cancelNoteBtn').addEventListener('click', () => {
            this.closeNoteModal();
        });

        document.getElementById('closeModal').addEventListener('click', () => {
            this.closeNoteModal();
        });

        // Admin tabs
        document.getElementById('usersTab').addEventListener('click', () => {
            this.showUsersManagement();
        });

        document.getElementById('settingsTab').addEventListener('click', () => {
            this.showSettingsManagement();
        });

        // User management
        document.getElementById('newUserBtn').addEventListener('click', () => {
            this.openUserModal();
        });

        document.getElementById('saveUserBtn').addEventListener('click', () => {
            this.saveUser();
        });

        document.getElementById('cancelUserBtn').addEventListener('click', () => {
            this.closeUserModal();
        });

        document.getElementById('closeUserModal').addEventListener('click', () => {
            this.closeUserModal();
        });

        // Settings
        document.getElementById('saveSettingsBtn').addEventListener('click', () => {
            this.saveSettings();
        });

        // Modal close on outside click
        document.getElementById('noteModal').addEventListener('click', (e) => {
            if (e.target.id === 'noteModal') {
                this.closeNoteModal();
            }
        });

        document.getElementById('userModal').addEventListener('click', (e) => {
            if (e.target.id === 'userModal') {
                this.closeUserModal();
            }
        });
    }

    setupActivityTracking() {
        const events = ['mousedown', 'mousemove', 'keypress', 'scroll', 'touchstart', 'click'];
        
        events.forEach(event => {
            document.addEventListener(event, () => {
                this.resetIdleTimer();
            }, true);
        });
    }

    startIdleTimer() {
        this.idleTimeout = setInterval(() => {
            const now = Date.now();
            if (now - this.lastActivity > this.idleTime) {
                if (!this.isIdle) {
                    this.handleIdleTimeout();
                }
            }
        }, 1000);
    }

    resetIdleTimer() {
        this.lastActivity = Date.now();
        this.isIdle = false;
    }

    handleIdleTimeout() {
        this.isIdle = true;
        if (this.currentUser) {
            alert('Session expired due to inactivity. You will be logged out.');
            this.handleLogout();
        }
    }

    async checkAuthStatus() {
        try {
            const response = await fetch('/api/user', {
                credentials: 'include'
            });
            if (response.ok) {
                const data = await response.json();
                this.currentUser = data.user;
                console.log('User authenticated:', this.currentUser);
                this.showMainApp();
                this.loadNotes();
                this.loadSettings();
            } else {
                console.log('Authentication failed, showing login page');
                this.showLoginPage();
            }
        } catch (error) {
            console.error('Auth check failed:', error);
            this.showLoginPage();
        }
    }

    async handleLogin() {
        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;
        const errorDiv = document.getElementById('loginError');

        try {
            const response = await fetch('/api/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                credentials: 'include',
                body: JSON.stringify({ username, password }),
            });

            const data = await response.json();

            if (response.ok) {
                this.currentUser = data.user;
                this.showMainApp();
                this.loadNotes();
                this.loadSettings();
                errorDiv.textContent = '';
            } else {
                errorDiv.textContent = data.error || 'Login failed';
            }
        } catch (error) {
            console.error('Login error:', error);
            errorDiv.textContent = 'Login failed. Please try again.';
        }
    }

    async handleLogout() {
        try {
            await fetch('/api/logout', { 
                method: 'POST',
                credentials: 'include'
            });
            this.currentUser = null;
            this.showLoginPage();
            this.resetIdleTimer();
        } catch (error) {
            console.error('Logout error:', error);
        }
    }

    showLoginPage() {
        document.getElementById('loginPage').classList.remove('hidden');
        document.getElementById('mainApp').classList.add('hidden');
    }

    showMainApp() {
        document.getElementById('loginPage').classList.add('hidden');
        document.getElementById('mainApp').classList.remove('hidden');
        
        // Show admin tab if user is admin
        if (this.currentUser && this.currentUser.role === 'admin') {
            document.getElementById('adminTab').style.display = 'block';
        }
        
        document.getElementById('userDisplay').textContent = 
            `Welcome, ${this.currentUser.username} (${this.currentUser.role})`;
    }

    showNotesSection() {
        document.getElementById('notesSection').classList.remove('hidden');
        document.getElementById('adminSection').classList.add('hidden');
        document.getElementById('notesTab').classList.add('active');
        document.getElementById('adminTab').classList.remove('active');
        this.loadNotes();
    }

    showAdminSection() {
        document.getElementById('notesSection').classList.add('hidden');
        document.getElementById('adminSection').classList.remove('hidden');
        document.getElementById('notesTab').classList.remove('active');
        document.getElementById('adminTab').classList.add('active');
        this.showUsersManagement();
    }

    showUsersManagement() {
        document.getElementById('usersManagement').classList.remove('hidden');
        document.getElementById('settingsManagement').classList.add('hidden');
        document.getElementById('usersTab').classList.add('active');
        document.getElementById('settingsTab').classList.remove('active');
        this.loadUsers();
    }

    showSettingsManagement() {
        document.getElementById('usersManagement').classList.add('hidden');
        document.getElementById('settingsManagement').classList.remove('hidden');
        document.getElementById('usersTab').classList.remove('active');
        document.getElementById('settingsTab').classList.add('active');
        this.loadSettings();
    }

    async loadNotes() {
        try {
            const response = await fetch('/api/notes', {
                credentials: 'include'
            });
            if (response.ok) {
                const notes = await response.json();
                this.displayNotes(notes);
            }
        } catch (error) {
            console.error('Failed to load notes:', error);
        }
    }

    displayNotes(notes) {
        const notesList = document.getElementById('notesList');
        notesList.innerHTML = '';

        notes.forEach(note => {
            const noteCard = document.createElement('div');
            noteCard.className = 'note-card';
            noteCard.innerHTML = `
                <div class="note-title">${this.escapeHtml(note.title)}</div>
                <div class="note-content">${this.escapeHtml(note.content)}</div>
                <div class="note-actions">
                    <button class="btn-primary btn-small" onclick="app.editNote(${note.id})">Edit</button>
                    <button class="btn-danger btn-small" onclick="app.deleteNote(${note.id})">Delete</button>
                </div>
            `;
            notesList.appendChild(noteCard);
        });
    }

    openNoteModal(noteId = null) {
        // Check if user is authenticated
        if (!this.currentUser) {
            alert('You must be logged in to create or edit notes. Please log in first.');
            this.showLoginPage();
            return;
        }

        const modal = document.getElementById('noteModal');
        const title = document.getElementById('modalTitle');
        const noteTitle = document.getElementById('noteTitle');
        const noteContent = document.getElementById('noteContent');

        if (noteId) {
            title.textContent = 'Edit Note';
            // Load note data
            this.loadNoteForEdit(noteId);
        } else {
            title.textContent = 'New Note';
            noteTitle.value = '';
            noteContent.value = '';
        }

        modal.classList.remove('hidden');
        noteTitle.focus();
    }

    async loadNoteForEdit(noteId) {
        try {
            const response = await fetch(`/api/notes`, {
                credentials: 'include'
            });
            if (response.ok) {
                const notes = await response.json();
                const note = notes.find(n => n.id === noteId);
                if (note) {
                    document.getElementById('noteTitle').value = note.title;
                    document.getElementById('noteContent').value = note.content;
                }
            }
        } catch (error) {
            console.error('Failed to load note:', error);
        }
    }

    closeNoteModal() {
        document.getElementById('noteModal').classList.add('hidden');
    }

    async saveNote() {
        const title = document.getElementById('noteTitle').value;
        const content = document.getElementById('noteContent').value;

        if (!title || !content) {
            alert('Please fill in all fields');
            return;
        }

        // Check if user is authenticated
        if (!this.currentUser) {
            alert('You must be logged in to save notes. Please log in first.');
            this.showLoginPage();
            return;
        }

        try {
            const response = await fetch('/api/notes', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                credentials: 'include',
                body: JSON.stringify({ title, content }),
            });

            if (response.ok) {
                this.closeNoteModal();
                this.loadNotes();
            } else if (response.status === 401) {
                alert('Session expired. Please log in again.');
                this.currentUser = null;
                this.showLoginPage();
            } else {
                const data = await response.json();
                alert(data.error || 'Failed to save note');
            }
        } catch (error) {
            console.error('Failed to save note:', error);
            alert('Failed to save note');
        }
    }

    editNote(noteId) {
        this.openNoteModal(noteId);
    }

    async deleteNote(noteId) {
        if (!confirm('Are you sure you want to delete this note?')) {
            return;
        }

        try {
            const response = await fetch(`/api/notes/${noteId}`, {
                method: 'DELETE',
                credentials: 'include'
            });

            if (response.ok) {
                this.loadNotes();
            } else {
                const data = await response.json();
                alert(data.error || 'Failed to delete note');
            }
        } catch (error) {
            console.error('Failed to delete note:', error);
            alert('Failed to delete note');
        }
    }

    async loadUsers() {
        try {
            const response = await fetch('/api/admin/users', {
                credentials: 'include'
            });
            if (response.ok) {
                const users = await response.json();
                this.displayUsers(users);
            }
        } catch (error) {
            console.error('Failed to load users:', error);
        }
    }

    displayUsers(users) {
        const usersList = document.getElementById('usersList');
        usersList.innerHTML = '';

        users.forEach(user => {
            const userCard = document.createElement('div');
            userCard.className = 'user-card';
            userCard.innerHTML = `
                <div class="user-info-card">
                    <div class="user-username">${this.escapeHtml(user.username)}</div>
                    <div class="user-email">${this.escapeHtml(user.email)}</div>
                </div>
                <div class="user-role">${user.role}</div>
                <div class="user-actions">
                    <button class="btn-danger btn-small" onclick="app.deleteUser(${user.id})">Delete</button>
                </div>
            `;
            usersList.appendChild(userCard);
        });
    }

    openUserModal() {
        const modal = document.getElementById('userModal');
        const title = document.getElementById('userModalTitle');
        
        title.textContent = 'Add User';
        document.getElementById('userUsername').value = '';
        document.getElementById('userEmail').value = '';
        document.getElementById('userPassword').value = '';
        document.getElementById('userRole').value = 'user';

        modal.classList.remove('hidden');
    }

    closeUserModal() {
        document.getElementById('userModal').classList.add('hidden');
    }

    async saveUser() {
        const username = document.getElementById('userUsername').value;
        const email = document.getElementById('userEmail').value;
        const password = document.getElementById('userPassword').value;
        const role = document.getElementById('userRole').value;

        if (!username || !email || !password) {
            alert('Please fill in all fields');
            return;
        }

        try {
            const response = await fetch('/api/admin/users', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                credentials: 'include',
                body: JSON.stringify({ username, email, password, role }),
            });

            if (response.ok) {
                this.closeUserModal();
                this.loadUsers();
            } else {
                const data = await response.json();
                alert(data.error || 'Failed to create user');
            }
        } catch (error) {
            console.error('Failed to create user:', error);
            alert('Failed to create user');
        }
    }

    async deleteUser(userId) {
        if (!confirm('Are you sure you want to delete this user?')) {
            return;
        }

        try {
            const response = await fetch(`/api/admin/users/${userId}`, {
                method: 'DELETE',
                credentials: 'include'
            });

            if (response.ok) {
                this.loadUsers();
            } else {
                const data = await response.json();
                alert(data.error || 'Failed to delete user');
            }
        } catch (error) {
            console.error('Failed to delete user:', error);
            alert('Failed to delete user');
        }
    }

    async loadSettings() {
        try {
            const response = await fetch('/api/admin/settings', {
                credentials: 'include'
            });
            if (response.ok) {
                const settings = await response.json();
                this.displaySettings(settings);
            }
        } catch (error) {
            console.error('Failed to load settings:', error);
        }
    }

    displaySettings(settings) {
        document.getElementById('idleTimeout').value = parseInt(settings.idle_timeout) / 1000;
        document.getElementById('protocol').value = settings.protocol;
        document.getElementById('httpsEnabled').checked = settings.https_enabled === 'true';
        document.getElementById('http2Enabled').checked = settings.http2_enabled === 'true';
        
        // Update idle timeout
        this.idleTime = parseInt(settings.idle_timeout);
    }

    async saveSettings() {
        const idleTimeout = document.getElementById('idleTimeout').value;
        const protocol = document.getElementById('protocol').value;
        const httpsEnabled = document.getElementById('httpsEnabled').checked;
        const http2Enabled = document.getElementById('http2Enabled').checked;

        try {
            const response = await fetch('/api/admin/settings', {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                },
                credentials: 'include',
                body: JSON.stringify({
                    idle_timeout: idleTimeout * 1000,
                    protocol,
                    https_enabled: httpsEnabled,
                    http2_enabled: http2Enabled
                }),
            });

            if (response.ok) {
                alert('Settings saved successfully');
                this.idleTime = idleTimeout * 1000;
            } else {
                const data = await response.json();
                alert(data.error || 'Failed to save settings');
            }
        } catch (error) {
            console.error('Failed to save settings:', error);
            alert('Failed to save settings');
        }
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
}

// Initialize the app
const app = new NotesApp();
