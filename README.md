# Docker Compose – Workspace 🐳

This repository hosts multiple independent Docker Compose projects. Each project is configured via a local `.env` file, based on a `.env.example` provided in its folder. `.env` files are not tracked by Git.

## 🛠️ Prerequisites
- Docker and Docker Compose installed
- Free ports available according to your services
- Create host directories for assets/volumes when needed

## 🚀 Usage
- Copy `.env.example` to `.env` in each project.
- Adjust `.env` values to your environment (ports, paths, passwords, etc.).
- Create the volume directories referenced by variables if needed.
- Start a project from its folder with `docker compose up -d`.

## ⚙️ Configuration Conventions
- `env_file`: all projects read their variables from a local `.env` file.
- Exposed ports: defined via variables in `.env` (e.g. `FOO_UI_PORT`, `FOO_API_PORT`). Compose maps these variables to internal ports (`"${FOO_UI_PORT}:<container_port>"`).
- Volume paths: defined via a base variable (e.g. `FOO_BASE_PATH`), with a default under `/home/<container_name>` (e.g. `/home/portainer`).
- Timezone: use `TZ` (e.g. `Europe/Paris`) to unify timezone.
- Restart policy: `restart: unless-stopped` applied by default to services.

## 🧩 Variable Prefix Convention
- Prefix variables per project to avoid collisions (e.g. `PIHOLE_*`, `PORTAINER_*`, `SEMAPHORE_*`).
- For a new project, use a generic prefix (e.g. `FOO_*`).

Minimal `.env.example` for a generic project:

```env
FOO_TZ=Europe/Paris
FOO_UI_PORT=8080
FOO_BASE_PATH=/home/foo
FOO_API_PORT=8081
FOO_DB_USER=foo
FOO_DB_PASS=changeme
```

## 📦 Service Management
- Start: `docker compose up -d`
- Stop: `docker compose down`
- Logs: `docker compose logs -f`
- Status: `docker compose ps`

## 📡 Exposed Ports by Project

### n8n
| Env variable | Default value (.env.example) | Container port | Protocol | Purpose |
|---|---|---|---|---|
| `N8N_WEB_PORT` | `5006` | `5678` | TCP | Web UI |

### pihole
| Env variable | Default value (.env.example) | Container port | Protocol | Purpose |
|---|---|---|---|---|
| `PIHOLE_DNS_TCP_PORT` | `53` | `53` | TCP | DNS |
| `PIHOLE_DNS_UDP_PORT` | `53` | `53` | UDP | DNS |
| `PIHOLE_WEB_PORT` | `5005` | `80` | TCP | Web UI |
| `PIHOLE_NTP_UDP_PORT` | `123` | `123` | UDP | NTP |

### portainer
| Env variable | Default value (.env.example) | Container port | Protocol | Purpose |
|---|---|---|---|---|
| `PORTAINER_UI_PORT` | `9000` | `9000` | TCP | Web UI |
| `PORTAINER_AGENT_TUNNEL_PORT` | `8000` | `8000` | TCP | Agent tunnel |

### semaphore
| Env variable | Default value (.env.example) | Container port | Protocol | Purpose |
|---|---|---|---|---|
| `SEMAPHORE_UI_PORT` | `3001` | `3000` | TCP | UI |

### mysql
| Env variable | Default value (.env.example) | Container port | Protocol | Purpose |
|---|---|---|---|---|
| `MYSQL_PORT` | `3306` | `3306` | TCP | MySQL |

### postgres
| Env variable | Default value (.env.example) | Container port | Protocol | Purpose |
|---|---|---|---|---|
| `POSTGRES_PORT` | `5432` | `5432` | TCP | PostgreSQL |

### redis
| Env variable | Default value (.env.example) | Container port | Protocol | Purpose |
|---|---|---|---|---|
| `REDIS_PORT` | `6379` | `6379` | TCP | Redis |

### wordpress_db
| Env variable | Default value (.env.example) | Container port | Protocol | Purpose |
|---|---|---|---|---|
| — | — | `3306` | TCP | MySQL (reachable only inside Docker network) |

### wordpress
| Env variable | Default value (.env.example) | Container port | Protocol | Purpose |
|---|---|---|---|---|
| `WORDPRESS_PORT` | `5007` | `80` | TCP | Web UI |

Note: `WORDPRESS_DB_HOST` defaults to `wordpress_db` (internal connection on `wordpress_network`).

### it-tools
| Env variable | Default value (.env.example) | Container port | Protocol | Purpose |
|---|---|---|---|---|
| `ITTOOLS_PORT` | `5008` | `80` | TCP | Web UI |

### vaultwarden
| Env variable | Default value (.env.example) | Container port | Protocol | Purpose |
|---|---|---|---|---|
| `VAULTWARDEN_PORT` | `5009` | `80` | TCP | HTTP API/UI |
| `VAULTWARDEN_WS_PORT` | `5010` | `3012` | TCP | WebSocket notifications |

### watchtower
| Env variable | Default value (.env.example) | Container port | Protocol | Purpose |
|---|---|---|---|---|
| — | — | — | — | No exposed port |

### snipe-it
| Env variable | Default value (.env.example) | Container port | Protocol | Purpose |
|---|---|---|---|---|
| `SNIPEIT_PORT` | `5011` | `80` | TCP | Web UI |

Note: `SNIPEIT_DB_HOST` defaults to `snipeit_db` (internal connection on `snipeit_network`).

### webprint
| Env variable | Default value (.env.example) | Container port | Protocol | Purpose |
|---|---|---|---|---|
| `WEBPRINT_PORT` | `5012` | `80` | TCP | Web UI |

Notes:
- Connects to CUPS at `WEBPRINT_CUPS_SERVER`:`WEBPRINT_CUPS_PORT` (default `host.docker.internal:631`).
- Ensure your host exposes CUPS and that `WEBPRINT_API_TOKEN` is set.

## 🧠 Best Practices
- Do not commit secrets: only `.env.example` is versioned; `.env` remains local.
- Prefix all environment variables per project to avoid collisions (`FOO_*`).
- Externalize ports and volumes via `.env` (e.g. `FOO_UI_PORT`, `FOO_BASE_PATH`).
- Standardize timezone via `TZ` and apply `restart: unless-stopped` to services.
- Create volume directories before starting and verify host permissions.
- Adjust paths according to OS (Windows: `C:\data\service`, Linux: `/home/service`).
- Validate configuration before starting: `docker compose config` and monitor with `docker compose logs -f`.

## 🔧 Troubleshooting
- Port conflicts: change port variables in `.env`.
- Missing volume directories: create the directories referenced by `<PROJECT>_BASE_PATH`.
- Access rights: some services require access to the Docker socket; ensure host permissions.
