# Docker Compose – Workspace 🐳

Ce dépôt sert de base pour héberger plusieurs projets Docker Compose indépendants. Chaque projet se configure via un fichier `.env` (local), à partir d’un modèle `.env.example` fourni dans son dossier. Les fichiers `.env` ne sont pas suivis par Git.

## 🛠️ Prérequis
- Docker et Docker Compose installés
- Ports libres selon vos services
- Création des dossiers d’assets/volumes sur l’hôte si nécessaire

## 🚀 Utilisation
- Copier le fichier `.env.example` en `.env` dans chaque projet.
- Adapter les valeurs du `.env` à votre environnement (ports, chemins, mots de passe, etc.).
- Créer les répertoires de volumes référencés par les variables si besoin.
- Démarrer un projet depuis son dossier avec `docker compose up -d`.

## ⚙️ Conventions de configuration
- `env_file`: tous les projets lisent leurs variables depuis un fichier `.env` local.
- Ports exposés: définis via des variables dans `.env` (ex. `FOO_UI_PORT`, `FOO_API_PORT`). Le compose mappe ces variables sur les ports internes (`"${FOO_UI_PORT}:<port_interne>"`).
- Chemins de volumes: définis via une variable de base (ex. `FOO_BASE_PATH`), avec une valeur par défaut sous `/home/<nom_du_conteneur>` (ex. `/home/portainer`).
- Fuseau horaire: utiliser `TZ` (ex. `Europe/Paris`) pour unifier le fuseau.
- Politique de redémarrage: `restart: unless-stopped` est appliquée par défaut aux services.

## 🧩 Convention de préfixe des variables
- Préfixer les variables par projet pour éviter les collisions (ex. `PIHOLE_*`, `PORTAINER_*`, `SEMAPHORE_*`).
- Pour un nouveau projet, utilisez un préfixe générique (ex. `FOO_*`).

Exemple minimal de `.env.example` pour un projet générique:

```env
FOO_TZ=Europe/Paris
FOO_UI_PORT=8080
FOO_BASE_PATH=/home/foo
FOO_API_PORT=8081
FOO_DB_USER=foo
FOO_DB_PASS=changeme
```

## 📦 Gestion des services
- Démarrer: `docker compose up -d`
- Arrêter: `docker compose down`
- Logs: `docker compose logs -f`
- État: `docker compose ps`

## 📡 Ports exposés par projet

### n8n
| Variable (.env) | Valeur par défaut (.env.example) | Port interne | Protocole | Usage |
|---|---|---|---|---|
| `N8N_WEB_PORT` | `5006` | `5678` | TCP | Interface web |

### pihole
| Variable (.env) | Valeur par défaut (.env.example) | Port interne | Protocole | Usage |
|---|---|---|---|---|
| `PIHOLE_DNS_TCP_PORT` | `53` | `53` | TCP | DNS |
| `PIHOLE_DNS_UDP_PORT` | `53` | `53` | UDP | DNS |
| `PIHOLE_WEB_PORT` | `5005` | `80` | TCP | Interface web |
| `PIHOLE_NTP_UDP_PORT` | `123` | `123` | UDP | NTP |

### portainer
| Variable (.env) | Valeur par défaut (.env.example) | Port interne | Protocole | Usage |
|---|---|---|---|---|
| `PORTAINER_UI_PORT` | `9000` | `9000` | TCP | Interface web |
| `PORTAINER_AGENT_TUNNEL_PORT` | `8000` | `8000` | TCP | Tunnel agent |

### semaphore
| Variable (.env) | Valeur par défaut (.env.example) | Port interne | Protocole | Usage |
|---|---|---|---|---|
| `SEMAPHORE_UI_PORT` | `3001` | `3000` | TCP | Interface UI |

### mysql
| Variable (.env) | Valeur par défaut (.env.example) | Port interne | Protocole | Usage |
|---|---|---|---|---|
| `MYSQL_PORT` | `3306` | `3306` | TCP | MySQL |

### postgres
| Variable (.env) | Valeur par défaut (.env.example) | Port interne | Protocole | Usage |
|---|---|---|---|---|
| `POSTGRES_PORT` | `5432` | `5432` | TCP | PostgreSQL |

### redis
| Variable (.env) | Valeur par défaut (.env.example) | Port interne | Protocole | Usage |
|---|---|---|---|---|
| `REDIS_PORT` | `6379` | `6379` | TCP | Redis |

### wordpress_db
| Variable (.env) | Valeur par défaut (.env.example) | Port interne | Protocole | Usage |
|---|---|---|---|---|
| `WORDPRESS_DB_PORT` | `3307` | `3306` | TCP | MySQL (WordPress DB) |

### wordpress
| Variable (.env) | Valeur par défaut (.env.example) | Port interne | Protocole | Usage |
|---|---|---|---|---|
| `WORDPRESS_PORT` | `5007` | `80` | TCP | Interface web |

### it-tools
| Variable (.env) | Valeur par défaut (.env.example) | Port interne | Protocole | Usage |
|---|---|---|---|---|
| `ITTOOLS_PORT` | `5008` | `80` | TCP | Interface web |

### vaultwarden
| Variable (.env) | Valeur par défaut (.env.example) | Port interne | Protocole | Usage |
|---|---|---|---|---|
| `VAULTWARDEN_PORT` | `5009` | `80` | TCP | HTTP API/UI |
| `VAULTWARDEN_WS_PORT` | `5010` | `3012` | TCP | WebSocket notifications |

### watchtower
| Variable (.env) | Valeur par défaut (.env.example) | Port interne | Protocole | Usage |
|---|---|---|---|---|
| — | — | — | — | Aucun port exposé |

## 🧠 Bonnes pratiques
- Ne pas commiter de secrets: seul `.env.example` est versionné; `.env` reste local.
- Préfixer toutes les variables d’environnement par projet pour éviter les collisions (`FOO_*`).
- Externaliser ports et volumes via `.env` (ex. `FOO_UI_PORT`, `FOO_BASE_PATH`).
- Uniformiser le fuseau horaire via `TZ` et appliquer `restart: unless-stopped` sur les services.
- Créer les dossiers de volumes avant le démarrage et vérifier les permissions côté hôte.
- Adapter les chemins selon l’OS (Windows: `C:\data\service`, Linux: `/home/service`).
- Valider la configuration avant démarrage: `docker compose config` et surveiller avec `docker compose logs -f`.

## 🔧 Dépannage
- Conflits de ports: modifier les variables de ports dans `.env`.
- Dossiers de volumes manquants: créer les répertoires référencés par `<PROJET>_BASE_PATH`.
- Droits d’accès: certains services nécessitent l’accès au socket Docker; assurer les permissions côté hôte.
