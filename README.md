*This project has been created as part of the 42 curriculum by aroullea*

# Inception

## Description

**Inception** is a Docker infrastructure project whose objective is to deploy a complete stack of interconnected services, each running in its own container, respecting security, data persistence and isolation constraints.

All services are built from **the penultimate stable version of Alpine Linux, i.e. version 3.22**, without using preconfigured images.

The infrastructure is orchestrated via **Docker Compose**, with:
- a dedicated Docker network
- persistent volumes
- independent but interconnected services

---

### Overall architecture

The stack is made up of the following services:

- **Nginx** : web server and HTTPS reverse proxy
- **WordPress** : web application (PHP-FPM)
- **MariaDB** : relational database management system
- **Redis** : (Remote Dictionary Server) memory cache for WordPress
- **FTP (vsftpd)** : (File Transfer Protocol) file transfer
- **Adminer** : database administration interface
- **Netdata** : infrastructure monitoring platform
- **Static Website** : very simple website

All services communicate over a **single Docker bridge network** called `inception`.

---

### Detailed services

#### Nginx
- Manages HTTPS (SSL/TLS) connections
- Acts as a reverse proxy to WordPress (PHP-FPM)
- Listening on port **443**

---

#### WordPress
- CMS written in PHP
- Run with **PHP-FPM**
- Connected to MariaDB for data storage
- Use Redis as object cache
- Files are stored in a shared volume

---

#### MariaDB
- Relational database
- Stores all WordPress data
- Automatic initialization via entrypoint script
- Users and databases created at startup
- Persistent data via volume

---

#### Redis
- High performance in-memory cache
- Used by WordPress to reduce SQL queries
- Improves overall site performance
- Persistent data via dedicated volume

---

#### FTP (vsftpd)
- FTP server for WordPress file management
- User created dynamically via environment variables
- Volume shared with WordPress

---

#### Adminer
- MariaDB database administration web interface
- Allows direct execution of SQL queries
- Connects to MariaDB service via Docker network
- System administration tool

---

#### Netdata
- Real-time monitoring tool
- Visualization :
  - CPU
  - memory
  - discs
  - Docker containers
- Accessible via port **19999**

---

#### Static Website
- Static website (HTML / CSS / JavaScript)
- Served via Nginx
- Simple website that presents the project services

---

## Instructions

To start and run all the services 
```bash
make or make up
```

To stop and delete the containers and the network created by Docker Compose
```bash
make down
```

To stop the containers without removing them and without removing the network
```bash
make stop
```

To start existing containers
```bash
make start
```
-> Only works after a stop

To restart the containers
```bash
make restart
```
-> Entrypoints are restarted
-> Equivalent to 
```bash
make stop
make start
```
