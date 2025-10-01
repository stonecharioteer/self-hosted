# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a self-hosted infrastructure repository containing Docker Compose configurations for various services deployed across multiple machines. The repository is organized by service stacks, each with its own directory and docker-compose.yml file.

## Architecture

The repository contains three main service stacks:

1. **media-stack**: Comprehensive media server setup deployed on EQI12 within Proxmox LXC container (192.168.100.230)
   - Services: Jellyfin (media streaming), qBittorrent (torrents), Samba (file sharing), Syncthing (file sync), Suwayomi (manga), FreshRSS (RSS reader), Karakeep (web archiver)
   - All services use `network_mode: host` for direct network access
   - Shared data volume: `/mnt/data/toshiba-4tb-001`
   - User context: PUID=1000, PGID=1000
   - Timezone: Asia/Kolkata

2. **syncthing**: Standalone Syncthing instance for file synchronization
   - Hostname: `eqr5-syncthing`
   - Uses `network_mode: host` for discovery and performance
   - Data root: `$HOME/syncthing`
   - Config stored in `./config` (gitignored to prevent credential leaks)
   - Web UI: 0.0.0.0:8384

3. **youtube-archivist**: Tube Archivist setup for YouTube content archival (192.168.100.195:8000)
   - Three-service stack: tubearchivist (web), archivist-redis, archivist-es (Elasticsearch)
   - Elasticsearch configuration: 1GB heap size, single-node discovery, security enabled
   - Data organized in `./data/` subdirectories

4. **openwrt**: OpenWRT router configuration files and backups (not a service stack)
   - Contains DHCP configs, UCI backups, MWAN3 failover scripts

## Common Commands

### Managing Services

All services are managed using Docker Compose v2 syntax:

```bash
# Start a service stack (from within the stack directory)
docker compose up -d

# Stop a service stack
docker compose down

# View logs
docker compose logs -f [service_name]

# Restart a specific service
docker compose restart [service_name]

# Pull latest images
docker compose pull

# Rebuild and restart
docker compose up -d --force-recreate
```

### Important Notes

- All docker-compose.yml files use modern Docker Compose v2.39+ syntax (no version field)
- Most services run as PUID=1000, PGID=1000 to match host permissions
- All services use `restart: unless-stopped` or `restart: always` for fault tolerance
- The media-stack uses a single shared external volume (`/mnt/data/toshiba-4tb-001`)
- Syncthing config is gitignored to prevent accidental credential commits

## Network Architecture

- Services use `network_mode: host` for direct network access and performance
- Media stack deployed on 192.168.100.230
- YouTube archivist on 192.168.100.195
- Syncthing web UI listens on all interfaces (0.0.0.0:8384)

## Service-Specific Details

### Jellyfin
- Hardware transcoding enabled via `/dev/dri` (Intel iGPU)
- Temporary transcoding directory: 4GB tmpfs mount
- Port: 8096

### qBittorrent
- Web UI port: 8080
- Download path integrated with Jellyfin media library

### Karakeep
- Multi-container setup: web app, Chrome for screenshots, Meilisearch for indexing
- Chrome container needs `shm_size: 2gb` to prevent crashes
- Port: 23001

### FreshRSS
- Auto-syncs extensions from GitHub on startup via separate git container
- Cron updates every 20 minutes
- Port: 18123

### Suwayomi
- Custom extension repository configured for manga sources
- Port: 4567
