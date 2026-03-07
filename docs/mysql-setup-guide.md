# MySQL Installation & Configuration Guide

## Prerequisites

- Terminal access
- **macOS**: Homebrew installed
- **WSL/Ubuntu**: Ubuntu 20.04+ on WSL2

---

## Installation

### macOS (Homebrew)

```bash
# Install MySQL 8.0
brew install mysql@8.0

# Link MySQL 8.0 to make it available in PATH
brew link mysql@8.0 --force

# Start MySQL service
brew services start mysql@8.0
```

### WSL/Ubuntu (APT)

```bash
# Update package index
sudo apt update

# Install MySQL Server
sudo apt install mysql-server -y

# Start and enable MySQL service
sudo systemctl start mysql
sudo systemctl enable mysql
```

---

## Initial Configuration

### 1. Check Default Root Setup

Connect to MySQL as root:

**macOS:**
```bash
mysql -u root  # No password by default
```

**WSL/Ubuntu:**
```bash
sudo mysql  # Uses socket authentication
```

Verify root configuration:

```sql
SELECT user, host, plugin FROM mysql.user WHERE user = 'root';
EXIT;
```

**Expected output (macOS):**
```
+------+-----------+-----------------------+
| user | host      | plugin                |
+------+-----------+-----------------------+
| root | localhost | caching_sha2_password |
+------+-----------+-----------------------+
```

**Expected output (WSL/Ubuntu):**
```
+------+-----------+-------------+
| user | host      | plugin      |
+------+-----------+-------------+
| root | localhost | auth_socket |
+------+-----------+-------------+
```

### 2. Secure MySQL Installation

**macOS:**
```bash
mysql_secure_installation
```

- Enter current password: Press Enter (blank)
- Set root password: Yes → Choose strong password
- Remove anonymous users: Yes
- Disallow root login remotely: Yes
- Remove test database: Yes
- Reload privilege tables: Yes

**WSL/Ubuntu:**
```bash
sudo mysql_secure_installation
```

- VALIDATE PASSWORD component: Your choice
- Set root password: Skip (keep socket auth recommended)
- Remove anonymous users: Yes
- Disallow root login remotely: Yes
- Remove test database: Yes
- Reload privilege tables: Yes

---

## Create Application User

Connect as root:

**macOS:**
```bash
mysql -u root -p
```

**WSL/Ubuntu:**
```bash
sudo mysql
```

Create appuser with full privileges:

```sql
-- Create appuser with password authentication
CREATE USER 'appuser'@'localhost' IDENTIFIED BY 'Password@123';
GRANT ALL PRIVILEGES ON *.* TO 'appuser'@'localhost' WITH GRANT OPTION;

-- Allow connections from any host (optional, development only)
CREATE USER 'appuser'@'%' IDENTIFIED BY 'Password@123';
GRANT ALL PRIVILEGES ON *.* TO 'appuser'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;

-- Verify users
SELECT user, host, plugin FROM mysql.user WHERE user IN ('root', 'appuser');
EXIT;
```

---

## Configure MySQL Settings (Optional)

### Edit Configuration File

**macOS:**
```bash
nano /opt/homebrew/etc/my.cnf
```

**WSL/Ubuntu:**
```bash
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
```

### Recommended Settings

**macOS** (`/opt/homebrew/etc/my.cnf`):
```ini
[mysqld]
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci
max_connections=200
connect_timeout=10
innodb_buffer_pool_size=512M
innodb_log_file_size=128M
local_infile=0
skip-symbolic-links
log_bin=mysql-bin
binlog_expire_logs_seconds=604800
log_error=/opt/homebrew/var/mysql/error.log

[client]
default-character-set=utf8mb4
```

**WSL/Ubuntu** (`/etc/mysql/mysql.conf.d/mysqld.cnf` - add to `[mysqld]` section):
```ini
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci
max_connections=200
bind-address=0.0.0.0
innodb_buffer_pool_size=512M
innodb_log_file_size=128M
local_infile=0
log_error=/var/log/mysql/error.log
```

### Restart MySQL

**macOS:**
```bash
brew services restart mysql@8.0
```

**WSL/Ubuntu:**
```bash
sudo systemctl restart mysql
```

---

## Verify Installation

**macOS:**
```bash
# Test root
mysql -u root -p -e "SELECT USER(), CURRENT_USER();"

# Test appuser
mysql -u appuser -p -e "SELECT USER(), CURRENT_USER();"
```

**WSL/Ubuntu:**
```bash
# Test root (socket auth)
sudo mysql -e "SELECT USER(), CURRENT_USER();"

# Test appuser
mysql -u appuser -p -e "SELECT USER(), CURRENT_USER();"
```

---

## MySQL Workbench (GUI Tool)

### Installation

**macOS:**
```bash
brew install --cask mysqlworkbench
```

**WSL/Ubuntu:**

Download from: [https://dev.mysql.com/downloads/workbench/](https://dev.mysql.com/downloads/workbench/)

Or install on Windows and connect to WSL MySQL using WSL IP address.

### Connecting to Local MySQL

1. Open MySQL Workbench
2. Click **"+"** next to "MySQL Connections"
3. Enter connection details:
   - **Connection Name**: `Local MySQL Server`
   - **Hostname**: `127.0.0.1` (or WSL IP for Windows connection)
   - **Port**: `3306`
   - **Username**: `appuser`
   - **Password**: Click "Store in Keychain" and enter `Password@123`
4. Click **"Test Connection"**
5. Click **"OK"**

MySQL Workbench provides:
- Visual database designer and ERD tools
- Query editor with syntax highlighting
- Database administration interface
- Import/Export wizards
- Performance monitoring
- User management

---

## File Locations Reference

| Purpose | macOS | WSL/Ubuntu |
|---------|-------|------------|
| Main configuration | `/opt/homebrew/etc/my.cnf` | `/etc/mysql/mysql.conf.d/mysqld.cnf` |
| Data directory | `/opt/homebrew/var/mysql/` | `/var/lib/mysql/` |
| Error log | `/opt/homebrew/var/mysql/error.log` | `/var/log/mysql/error.log` |
| Socket file | `/tmp/mysql.sock` | `/var/run/mysqld/mysqld.sock` |
| Binary logs | `/opt/homebrew/var/mysql/mysql-bin.*` | N/A (enable in config) |
| PID file | `/opt/homebrew/var/mysql/*.pid` | `/var/run/mysqld/mysqld.pid` |

---

## Common Commands

### macOS

```bash
# Service management
brew services start mysql@8.0
brew services stop mysql@8.0
brew services restart mysql@8.0
brew services info mysql@8.0

# Connect
mysql -u root -p
mysql -u appuser -p

# Logs
tail -f /opt/homebrew/var/mysql/error.log
```

### WSL/Ubuntu

```bash
# Service management
sudo systemctl start mysql
sudo systemctl stop mysql
sudo systemctl restart mysql
sudo systemctl status mysql

# Connect
sudo mysql  # root (socket auth)
mysql -u appuser -p

# Logs
sudo tail -f /var/log/mysql/error.log
```

### Common to Both

```bash
# Connect to specific database
mysql -u appuser -p database_name

# Execute SQL from command line
mysql -u appuser -p -e "SHOW DATABASES;"

# Import SQL file
mysql -u appuser -p database_name < backup.sql

# Export database
mysqldump -u appuser -p database_name > backup.sql
```

---

## WSL-Specific Notes

**Accessing MySQL from Windows:**

1. Edit `/etc/mysql/mysql.conf.d/mysqld.cnf`:
   ```ini
   bind-address=0.0.0.0
   ```

2. Restart MySQL:
   ```bash
   sudo systemctl restart mysql
   ```

3. Find WSL IP:
   ```bash
   hostname -I
   ```

4. Connect from Windows using this IP and `appuser` credentials

---

## Security Best Practices

⚠️ **Important Security Notes:**

1. **Set a strong root password** during `mysql_secure_installation` (macOS)
2. **Change default password** (`Password@123`) to a strong, unique password
3. **Never commit** passwords or configuration files with credentials to version control
4. **Use environment variables** for passwords in production applications
5. **Restrict appuser@'%'** in production (only allow specific hosts)
6. **Regularly update** MySQL to get security patches
7. **Enable SSL/TLS** for remote connections in production
8. **Regularly backup** your databases

---

## Troubleshooting

### MySQL won't start

**macOS:**
```bash
cat /opt/homebrew/var/mysql/error.log
lsof -i :3306
rm /tmp/mysql.sock
mysql.server start
```

**WSL/Ubuntu:**
```bash
sudo cat /var/log/mysql/error.log
sudo lsof -i :3306
sudo rm /var/run/mysqld/mysqld.sock
sudo systemctl restart mysql
```

### Authentication issues

```bash
# Verify users (macOS)
mysql -u root -p -e "SELECT user, host, plugin FROM mysql.user;"

# Verify users (WSL/Ubuntu)
sudo mysql -e "SELECT user, host, plugin FROM mysql.user;"

# Reset appuser password
sudo mysql -e "ALTER USER 'appuser'@'localhost' IDENTIFIED BY 'NewPassword123';"
```

### Can't connect from application

```bash
# Check if MySQL is listening
netstat -an | grep 3306

# Verify privileges
sudo mysql -e "SHOW GRANTS FOR 'appuser'@'localhost';"

# Check bind-address (should be 0.0.0.0 or commented out)
# macOS:
grep bind-address /opt/homebrew/etc/my.cnf

# WSL/Ubuntu:
grep bind-address /etc/mysql/mysql.conf.d/mysqld.cnf
```

---

## Additional Resources

- [MySQL Official Documentation](https://dev.mysql.com/doc/)
- [MySQL Security Guide](https://dev.mysql.com/doc/refman/8.0/en/security.html)
- [MySQL Performance Tuning](https://dev.mysql.com/doc/refman/8.0/en/optimization.html)
- [MySQL Workbench Documentation](https://dev.mysql.com/doc/workbench/en/)
