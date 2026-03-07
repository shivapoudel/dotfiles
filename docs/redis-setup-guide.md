# Redis Installation & Configuration Guide (macOS)

## Prerequisites

- Terminal access
- macOS with Homebrew installed

## Installation

### 1. Install Redis

```bash
brew install redis
```

This installs Redis and automatically sets up the service to run on system startup.

### 2. Configure Redis

Open the Redis configuration file:

```bash
code /opt/homebrew/etc/redis.conf
```

Add or modify the following settings:

```conf
# Network
tcp-backlog 128                            # Max number of pending connections

# Security
aclfile /opt/homebrew/etc/redis/users.acl  # ACL file location

# Memory Management
maxmemory 512mb                            # Maximum memory limit
maxmemory-policy allkeys-lfu               # Eviction policy (Least Frequently Used)
```

**Configuration Explained:**
- `tcp-backlog`: Controls the queue size for pending connections
- `aclfile`: Points to the Access Control List file for user authentication
- `maxmemory`: Prevents Redis from consuming unlimited memory
- `maxmemory-policy allkeys-lfu`: When memory limit is reached, evicts least frequently used keys

### 3. Set Up Access Control (ACL)

Create the ACL directory and file:

```bash
# Create directory for ACL file.
mkdir -p /opt/homebrew/etc/redis

# Create ACL file with application user and disabled default user.
cat > /opt/homebrew/etc/redis/users.acl << 'EOF'
user appuser on >Password@123 ~* +@all
user default off
EOF
```

**ACL Rules Explained:**
- `user appuser on`: Creates user 'appuser' and enables it
- `>Password@123`: Sets the password (change this to a secure password!)
- `~*`: Grants access to all keys
- `+@all`: Grants permission to all commands
- `user default off`: Disables the default user for security

### 4. Restart Redis and Save Configuration

```bash
# Restart Redis service
brew services restart redis

# Connect and save ACL configuration permanently
redis-cli --no-auth-warning --user appuser --pass Password@123 ACL SAVE
```

### 5. Verify Installation

```bash
# Check Redis status
brew services info redis

# Test connection
redis-cli --no-auth-warning --user appuser --pass Password@123 ping
# Should return: PONG
```

## Redis Insight (GUI Tool)

For easier data visualization and management, install **Redis Insight**:

### Installation

```bash
brew install --cask redis-insight
```

Or download from: [https://redis.io/insight/](https://redis.io/insight/)

### Connecting to Your Local Redis

1. Open Redis Insight
2. Click **"Add Redis Database"**
3. Click **"Connection Settings"**
4. Enter connection details:
   - **Database Alias**: `Local Redis`
   - **Host**: `localhost` or `127.0.0.1`
   - **Port**: `6379` (default)
   - **Username**: `appuser`
   - **Password**: `Password@123` (change this to a secure password!)
5. Click **"Add Redis Database"**

Redis Insight provides:
- Visual key browser and editor
- Real-time performance monitoring
- CLI integrated into the GUI
- Query profiling and slowlog analysis
- Memory analysis tools

## File Locations Reference

| Purpose | Path |
|---------|------|
| Main configuration | `/opt/homebrew/etc/redis.conf` |
| ACL users file | `/opt/homebrew/etc/redis/users.acl` |
| Data directory | `/opt/homebrew/var/db/redis/` |
| RDB snapshot | `/opt/homebrew/var/db/redis/dump.rdb` |
| Log file | `/opt/homebrew/var/log/redis.log` |
| PID file | `/opt/homebrew/var/run/redis.pid` |

## Common Commands

```bash
# Start Redis
brew services start redis

# Stop Redis
brew services stop redis

# Restart Redis
brew services restart redis

# Check status
brew services info redis

# Connect with authentication
redis-cli --user appuser --pass Password@123

# View logs
tail -f /opt/homebrew/var/log/redis.log

# Flush all data (use with caution!)
redis-cli --no-auth-warning --user appuser --pass Password@123 FLUSHALL
```

## Security Best Practices

⚠️ **Important Security Notes:**

1. **Change the default password** (`Password@123`) to a strong, unique password.
2. **Never commit** ACL files or passwords to version control.
3. Consider using environment variables for passwords in production.
4. Restrict network access if Redis is exposed beyond localhost.
5. Regularly update Redis to get security patches.

## Troubleshooting

### Redis won't start
```bash
# Check for errors in the log
cat /opt/homebrew/var/log/redis.log

# Ensure config file syntax is correct
redis-server /opt/homebrew/etc/redis.conf --test-memory 1
```

### Authentication issues
```bash
# Verify ACL file exists and is readable
cat /opt/homebrew/etc/redis/users.acl

# Check current ACL users
redis-cli --no-auth-warning --user appuser --pass Password@123 ACL LIST
```

### Memory issues
```bash
# Check current memory usage
redis-cli --no-auth-warning --user appuser --pass Password@123 INFO memory

# View memory stats in human-readable format
redis-cli --no-auth-warning --user appuser --pass Password@123 --stat
```

## Additional Resources

- [Redis Official Documentation](https://redis.io/docs/)
- [Redis ACL Documentation](https://redis.io/docs/management/security/acl/)
- [Redis Configuration Guide](https://redis.io/docs/management/config/)
- [Redis Insight Documentation](https://redis.io/docs/ui/insight/)
