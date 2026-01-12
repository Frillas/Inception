# User Documentation - Inception

This document explains how to use and manage the **inception** project.
It is intended for users and administrators who want to run, access and verify the services.

---

## 1. Services Provided

The project deploys a complete Docker-based infrastructure composed of the following services:

- **Nginx**
	Web server and HTTPS reverse proxy.
	Handle SSL/TLS serves WordPress over port **443**

- **WordPress**
	Content Management System (CMS) used to create and manage the website content.

- **MariaDB**
	Relational database storing all WordPress data (users, posts, settings).

- **Redis**
	In-memory cache used by WordPress to improve performance.

- **FTP (vsftpd)**
	FTP server allowing file transfers to the WordPress directory.

- **
