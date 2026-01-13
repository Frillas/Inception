# Developer Documentation - Inception

This Document explains how a developer can set up, build, run and maintain the **Inception project.**
It focuses on environment configuration, Docker infrastructur, data persistence and container management.

## 1. Project Overview

Inception is a Docker-based infrastructure project composed of multiple interconnected services.
Each service runs in its own container, built from alpine Linux and is orchestrated using Docker Compose.

The infrastructure relies on:
	- Docker containers
	- A dedicated Docker bridge network
	- Persistent volumes for critical data
	- Environment variables for configuration

## 2. Prerequisites

- Docker
- Make

The project has been developed and tested on Linux.

## 3. Environment setup

### 3.1 Directory Structure

Before launching the project, persistent data directories must exist on the host:

```bash
sudo mkdir /home/aroullea/data/wordpress
sudo mkdir /home/aroullea/data/mariadb
```

This directories are mounted as bind volumes inside containers to ensure data persistence.

### 3.2 Configuration File

Each service has its own configuration directory under requirements/ :
- requirements/nginx/conf
- requirements/mariadb/conf
- requirements/wordpress/conf
- requirements/bonus

Configuration files include:
- Nginx virtual host configuration
- MariaDB server configuration (my.cnf)
- Entrypoint scripts when required

All images are built locally.

### 3.3 Secrets Management

Sensitive information is stored in a .env file located next to the docker-compose.yml file.

Typical variables include:
- Database credentials
- WordPress credentials
- FTP user credentials

The .env file is:
- Not commited to version control
- injected into containers at runtime

This approache avoids hardcodind secrets in images or configuration files.

## 4. Build and Launch Process

### 4.1 Using the Makefile

The Makefile act as a wrapper around Docker Compose commands.
```bash
make			# build and start the project
make up			# same as make
make stop		# stop containers without removing them
make start		# start stopped containers
make restart	# restart containers (entrypoints re-executed)
make down		# stop and remove containers, networks, volumes
make clean		# remove containers, images, volumes
make fclean		# Full cleanup including orphan resources
```

### 4.2 Docker Compose

Docker Compose is responsible for:
- Building images
- Creating containers
- Managing the Docker network
- Mounting volumes
- Defining services dependencies

All services are connected to a single bridge network named inception.

## 5. Managing Containers and Volumes

Docker commands for development and debugging:

List running containers:
```bash
docker ps
```

Inspect a container:
```bash
docker inspect <container_name>
```

Access a container shell:
```bash
docker exec -it <container_name> sh
```

View logs:
```bash
docker logs <container_name>
```

Inspect the Docker network:
```bash
docker network inspect inception
```

## 6. Data Persistence

Persistent data is handled using bind-mounted volumes.

|**service**|**container path**|**Host Path**                 |
| :-------- | :--------------- | :--------------------------- |
|MariaDB    |/var/lib/mysql    |/home/aroullea/data/mariadb   |
|WordPress  |/vat/www/html     |/home/aroullea/data/wordpress |

Data stored in these directories is preserved across:
- Container restarts
- Image rebuilds
- Docker Compose down/up cycles

Redis does not require persistent storage for correct operation and can run without a volume.
