# User Documentation - Inception

This document explains how to use and manage the **inception** project.
It is intended for users and administrators who want to run, access and verify the services.

---

## 1. Services Provided

The project deploys a complete Docker-based infrastructure composed of the following services:

- **Nginx**
	- Web server and HTTPS reverse proxy.
	- Handle SSL/TLS serves WordPress over port **443**

- **WordPress**
	- Content Management System (CMS) used to create and manage the website content.

- **MariaDB**
	- Relational database storing all WordPress data (users, posts, settings).

- **Redis**
	- In-memory cache used by WordPress to improve performance.

- **FTP (vsftpd)**
	- FTP server allowing file transfers to the WordPress directory.

- **Adminer**
  	- Web interface to manage and inspect the MariaDB database.

- **Netdata**
	- Real-time monitoring tool for system and Docker containers.

- **Website**
	- A simple static website served via Nginx.
  
All services run in isolated Docker containers and communicate through a private Docker network.

---

## 2. Starting and stopping the project

### Prerequisites
- Docker
- Make

Before starting, ensure that the following directories exist on the host:
```bash
sudo mkdir /home/aroullea/data/wordpress
sudo mkdir /home/aroullea/data/mariadb
```

- Create .env file, (an example is provided at the root of the repository) and place it in the /srcs directory.

All credentials are stored in the .env and the file must be placed next to the docker-compose.yml file. 
- Typical variable include:
    - MariaDB root password
    - WordPress database name
    - WordPress database user and password
    - FTP user credentials
    
These variables are injected into containers at startup.

Add the domain to /etc/hosts:
```bash
127.0.0.1 aroullea.42.fr
```

Start the project
```bash
make
# or
make up
```

Stop the project (without deleting data)
```bash
make stop
```

Restart the project
```bash
make restart
```
This restarts containers and re-executes entrypoints if applicable

Stop and removes containers, networks and volumes
```bash
make down
```

Full cleanup (containers, images, volumes)
```bash
make fclean
```

## 3. Accessing the Services

### WordPress Website
- https://aroullea.42.fr
Accessible via HTTPS only (port 443)

### WordPress admin panel
- https://aroullea.42.fr/wp-admin
Requires WordPress credentials

### Adminer (Database administration)
- https://aroullea.42.fr:8081
- Login information:
    - **system:** MySQL
    - **Server:** mariadb
    - **Username:** wpuser
    - **Password:** wp_password
    - **Database:** wordpress
    
### Netdata (monitoring)
- http://aroullea.42.fr:19999
- Displays real-time metrics for:
    - CPU
    - Memory
    - Disk

### FTP Access

Login and password have to be created in .env file

In bash, write:
```bash
ftp aroullea.42.fr 2121
or
ftp 127.0.0.1 2121

login: ftpuser
password: FTPp@ssw0rd4242!!
```

FTP user home directory is shared with WordPress files

---

## 4. Checking that services are running correctly

List running containers
```bash
make ps
```

View Logs of all containers
```bash
make logs
```

To check logs for a specific service:
```bash
docker logs <container_name>
```

Functional Checks
- Website loads over HTTPS
- WordPress admin panel is accessible
- Adminer can connect to MariaDB
- FTP allows file upload/download
- Netdata displays live metrics
