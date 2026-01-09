*This project has been created as part of the 42 curriculum by aroullea*

# Inception

## Description

**Inception** est un projet d’infrastructure Docker dont l’objectif est de déployer une stack complète de services interconnectés,
chacun exécuté dans son propre conteneur, en respectant des contraintes de sécurité, de persistance des données et d’isolation.

Tous les services sont construits **à partir de l’avant-dernière version stable d’Alpine Linux, c'est à dire la version 3.22**, sans utiliser d’images préconfigurées.

L’infrastructure est orchestrée via **Docker Compose**, avec :
- un réseau Docker dédié
- des volumes persistants
- des services indépendants mais interconnectés

---

### Architecture globale

La stack est composée des services suivants :

- **Nginx** : serveur web et reverse proxy HTTPS
- **WordPress** : application web (PHP-FPM)
- **MariaDB** : base de données relationnelle
- **Redis** : cache mémoire pour WordPress
- **FTP (vsftpd)** : transfert de fichiers
- **Adminer** : interface d’administration de la base de données
- **Netdata** : monitoring de l’infrastructure
- **Static Website** : site web statique

Tous les services communiquent via un **réseau Docker bridge unique** nommé `inception`.

---

### Volumes

Les données critiques sont stockées dans des volumes persistants montés depuis l’hôte :

- **MariaDB**  
  Données stockées dans `/var/lib/mysql`

- **WordPress**  
  Fichiers du site stockés dans `/var/www/html`

- **Redis**  
  Données stockées dans `/data`

Ces volumes garantissent la persistance des données même après un arrêt ou une recréation des conteneurs.

---

### Services détaillés

#### Nginx
- Sert de point d’entrée unique
- Gère les connexions HTTPS (SSL/TLS)
- Fait office de reverse proxy vers WordPress (PHP-FPM)
- Écoute sur le port **443**

---

#### WordPress
- CMS écrit en PHP
- Exécuté avec **PHP-FPM**
- Connecté à MariaDB pour le stockage des données
- Utilise Redis comme cache objet
- Les fichiers sont stockés dans un volume partagé

---

#### MariaDB
- Base de données relationnelle
- Stocke l’ensemble des données WordPress
- Initialisation automatique via script d’entrypoint
- Utilisateurs et bases créés au démarrage
- Données persistantes via volume

---

#### Redis
- Cache en mémoire haute performance
- Utilisé par WordPress pour réduire les requêtes SQL
- Améliore les performances globales du site
- Données persistantes via volume dédié

---

#### FTP (vsftpd)
- Serveur FTP pour la gestion des fichiers WordPress
- Mode passif activé
- Utilisateur créé dynamiquement via variables d’environnement
- Volume partagé avec WordPress

---

#### Adminer
- Interface web d’administration de la base MariaDB
- Permet l’exécution directe de requêtes SQL
- Se connecte au service MariaDB via le réseau Docker
- Outil d’administration système (contourne WordPress)

---

#### Netdata
- Outil de monitoring temps réel
- Visualisation :
  - CPU
  - mémoire
  - disques
  - conteneurs Docker
- Accessible via le port **19999**

---

#### Static Website
- Site web statique (HTML / CSS / JavaScript)
- Servi via Nginx
- Site web simple qui les services du projet

---

## Instructions

```bash
make

