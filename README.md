*This project has been created as part of the 42 curriculum by aroullea*

# Inception

## Description

**Inception** is a Docker infrastructure project whose objective is to deploy a complete stack of interconnected services, each running in its own container, respecting security, data persistence and isolation constraints.

All services are built from **the penultimate stable version of Alpine Linux, i.e. version 3.22**, without relying on ready-to-use application images.

The infrastructure is orchestrated via **Docker Compose**, with:
- a dedicated Docker network
- persistent volumes
- independent but interconnected services

### Project design and technical choices

#### Use of Docker

This project is entirely built using **Docker** in order to ensure service isolation, reproductability and portability

Each service runs inside it's **own dedicated container**, built from a custom **Dockerfile** based on Alpine Linux.

**Docker Compose** is used as a orchestration tool to:
- define services and their dependencies
- manage a dedicated bridge network
- configure persistent volumes
- control the lifecycle of containers

This approach reflects a real-world containerized architecture, where each component is isolated, scalable and independently maintainable.

#### Main design choices

Several important design choices were made during the project:
- **Alpine Linux (3.22)** was chosen for all containers due to it's:
	- small footprint
	- simplicity
	- security-oriented design

- **One service per container**:
	- improves isolation
	- simplifies debugging
	- follows Docker best practices

- **Docker volumes for persistences**:
	- MariaDB and Wordpress data are stored outside containers
	- ensure data survival after container recreation

- **Single Docker network**:
	- allows services to communicate using service names
	- avoids exposing internal services unnecessarily

- **Nginx as a reverse proxy**
	- handles HTTPS traffic
	- forwards PHP requests to Wordpress via FastCGI

- **Redis as an optional cache layer**
	- improves Wordpress performance
 
The goal was to keep the infrastructure understandable and simple.

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
- Optional data persistence via dedicated volume

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
- Served via a dedicated Nginx container
- Simple website that presents the project services

---

## Instructions

In /etc/hosts, add this line
```bash
127.0.0.1 aroullea.42.fr
```

Then create 2 repositories in
```bash
/home/aroullea/data/wordpress
/home/aroullea/data/mariadb
```

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

To display the logs
```bash
make logs
```

To display the list of running containers
```bash
make ps
```

To stop and removes all containers, networks and all images used in Docker Compose
```bash
make clean
```

To stop and removes all containers, networks, all images used in Docker Compose
and to clean up orphaned containers from previous configurations
```bash
make fclean
```

---

## Ressources

List of classic references related to the topic:
- https://hub.docker.com/
- https://blog.stephane-robert.info/docs/conteneurs/images-conteneurs/
- https://blog.stackademic.com/understanding-docker-mounts-volumes-bind-mounts-and-tmpfs-f992185edc27
- https://mindsers.blog/fr/post/configurer-https-nginx-docker-lets-encrypt/
- https://domopi.eu/comment-administrer-une-base-de-donnees-avec-adminer/
- https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-docker-compose
- https://blog.microlinux.fr/formation-docker-13-compose/
- https://github.com/netdata/netdata/blob/master/packaging/docker/README.md
- https://hub.docker.com/r/delfer/alpine-ftp-server/

During the development of this project, an AI assistant was used as a **learning and support tool**.

The AI was mainly used to:
- clarify Docker and Docker Compose concepts
- understand container lifecycle, entrypoints, signals, and volumes
- analyze logs and runtime errors
- review configuration files (Dockerfiles, nginx.conf, scripts)
- provide advice on best practices
