# Redis Installation & Configuration Guide

## Prerequisites

- Terminal access
- **macOS**: Homebrew installed
- **WSL/Ubuntu**: Ubuntu 20.04+ on WSL2

---

## Installation

### macOS (Homebrew)

```bash
# Install Redis
brew install redis

# Start Redis service
brew services start redis
```

### WSL/Ubuntu (APT)

```bash
# Update package index
sudo apt update

# Install Redis
sudo apt install redis-server -y

# Start and enable Redis service
sudo systemctl start redis-server
sudo systemctl enable redis-server
```

---

## Configure Redis

### Edit Configuration File

**macOS:**
```bash
nano /opt/homebrew/etc/redis.conf
```

**WSL/Ubuntu:**
```bash
sudo nano /etc/redis/redis.conf
```

### Configuration Settings

Add or modify the following settings:

**macOS** (`/opt/homebrew/etc/redis.conf`):
```conf
# Network
tcp-backlog 128

# Security
aclfile /opt/homebrew/etc/redis/users.acl

# Memory Management
maxmemory 512mb
maxmemory-policy allkeys-lfu
```

**WSL/Ubuntu** (`/etc/redis/redis.conf`):
```conf
# Process Management
supervised systemd

# Security
aclfile /etc/redis/users.acl

# Memory Management
maxmemory 512mb
maxmemory-policy allkeys-lfu
```

**Configuration Explained:**
- `tcp-backlog`: Controls the queue size for pending connections
- `supervised systemd`: (Ubuntu only) Tells Redis to integrate with systemd
- `aclfile`: Points to the Access Control List file for user authentication
- `maxmemory`: Prevents Redis from consuming unlimited memory
- `maxmemory-policy allkeys-lfu`: When memory limit is reached, evicts least frequently used keys

---

## Set Up Access Control (ACL)

### Create ACL Directory and File

**macOS:**
```bash
# Create directory
mkdir -p /opt/homebrew/etc/redis

# Create ACL file
cat > /opt/homebrew/etc/redis/users.acl << 'EOF'
user appuser on >Password@123 ~* +@all
user default off
EOF
```

**WSL/Ubuntu:**
```bash
# Create ACL file
sudo bash -c 'cat > /etc/redis/users.acl << "EOF"
user appuser on >Password@123 ~* +@all
user default off
EOF'
```

**ACL Rules Explained:**
- `user appuser on`: Creates user 'appuser' and enables it
- `>Password@123`: Sets the password (change this to a secure password!)
- `~*`: Grants access to all keys
- `+@all`: Grants permission to all commands
- `user default off`: Disables the default user for security

---

## Restart Redis and Save Configuration

**macOS:**
```bash
# Restart Redis service
brew services restart redis

# Connect and save ACL configuration permanently
redis-cli --no-auth-warning --user appuser --pass Password@123 ACL SAVE
```

**WSL/Ubuntu:**
```bash
# Restart Redis service
sudo systemctl restart redis-server

# Connect and save ACL configuration permanently
redis-cli --no-auth-warning --user appuser --pass Password@123 ACL SAVE
```

---

## Verify Installation

```bash
# Check Redis status
# macOS:
brew services info redis

# WSL/Ubuntu:
sudo systemctl status redis-server

# Test connection (both platforms)
redis-cli --no-auth-warning --user appuser --pass Password@123 ping
# Should return: PONG
```

---

## Redis Insight (GUI Tool)

### Installation

**macOS:**
```bash
brew install --cask redis-insight
```

**WSL/Ubuntu:**

Download from: [https://redis.io/insight/](https://redis.io/insight/)

Or install on Windows and connect to WSL Redis using WSL IP address.

### Connecting to Local Redis

1. Open Redis Insight
2. Click **"Add Redis Database"**
3. Click **"Connection Settings"**
4. Enter connection details:
   - **Database Alias**: `Local Redis` (or any name you prefer)
   - **Host**: `localhost` or `127.0.0.1` (or WSL IP for Windows connection)
   - **Port**: `6379` (default)
   - **Username**: `appuser`
   - **Password**: `Password@123`
5. Click **"Add Redis Database"**

Redis Insight provides:
- Visual key browser and editor
- Real-time performance monitoring
- CLI integrated into the GUI
- Query profiling and slowlog analysis
- Memory analysis tools

---

## File Locations Reference

| Purpose | macOS | WSL/Ubuntu |
|---------|-------|------------|
| Main configuration | `/opt/homebrew/etc/redis.conf` | `/etc/redis/redis.conf` |
| ACL users file | `/opt/homebrew/etc/redis/users.acl` | `/etc/redis/users.acl` |
| Data directory | `/opt/homebrew/var/db/redis/` | `/var/lib/redis/` |
| RDB snapshot | `/opt/homebrew/var/db/redis/dump.rdb` | `/var/lib/redis/dump.rdb` |
| Log file | `/opt/homebrew/var/log/redis.log` | `/var/log/redis/redis-server.log` |
| PID file | `/opt/homebrew/var/run/redis.pid` | `/var/run/redis/redis-server.pid` |

---

## Common Commands

### macOS

```bash
# Service management
brew services start redis
brew services stop redis
brew services restart redis
brew services info redis

# Connect with authentication
redis-cli --no-auth-warning --user appuser --pass Password@123

# View logs
tail -f /opt/homebrew/var/log/redis.log

# Flush all data (use with caution!)
redis-cli --no-auth-warning --user appuser --pass Password@123 FLUSHALL
```

### WSL/Ubuntu

```bash
# Service management
sudo systemctl start redis-server
sudo systemctl stop redis-server
sudo systemctl restart redis-server
sudo systemctl status redis-server

# Connect with authentication
redis-cli --no-auth-warning --user appuser --pass Password@123

# View logs
sudo tail -f /var/log/redis/redis-server.log

# Flush all data (use with caution!)
redis-cli --no-auth-warning --user appuser --pass Password@123 FLUSHALL
```

---

## WSL-Specific Notes

**Accessing Redis from Windows:**

1. Edit `/etc/redis/redis.conf`:
   ```conf
   bind 0.0.0.0
   ```

2. Restart Redis:
   ```bash
   sudo systemctl restart redis-server
   ```

3. Find WSL IP:
   ```bash
   hostname -I
   ```

4. Connect from Windows using this IP and `appuser` credentials

---

## Security Best Practices

⚠️ **Important Security Notes:**

1. **Change the default password** (`Password@123`) to a strong, unique password
2. **Never commit** ACL files or passwords to version control
3. Consider using environment variables for passwords in production
4. Restrict network access if Redis is exposed beyond localhost
5. Regularly update Redis to get security patches

---

## Troubleshooting

### Redis won't start

**macOS:**
```bash
# Check for errors in the log
cat /opt/homebrew/var/log/redis.log

# Ensure config file syntax is correct
redis-server /opt/homebrew/etc/redis.conf --test-memory 1
```

**WSL/Ubuntu:**
```bash
# Check for errors in the log
sudo cat /var/log/redis/redis-server.log

# Check service status
sudo systemctl status redis-server

# Restart service
sudo systemctl restart redis-server
```

### Authentication issues

```bash
# Verify ACL file exists and is readable
# macOS:
cat /opt/homebrew/etc/redis/users.acl

# WSL/Ubuntu:
sudo cat /etc/redis/users.acl

# Check current ACL users
redis-cli --no-auth-warning --user appuser --pass Password@123 ACL LIST
```

### Memory issues

```bash
# Check current memory usage (both platforms)
redis-cli --no-auth-warning --user appuser --pass Password@123 INFO memory

# View memory stats in human-readable format
redis-cli --no-auth-warning --user appuser --pass Password@123 --stat
```

---

## Additional Resources

- [Redis Official Documentation](https://redis.io/docs/)
- [Redis ACL Documentation](https://redis.io/docs/management/security/acl/)
- [Redis Configuration Guide](https://redis.io/docs/management/config/)
- [Redis Insight Documentation](https://redis.io/docs/ui/insight/)
