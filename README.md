# self-hosted

## media-stack
EQI12 Proxmox LXC (pct) @ 192.168.100.230
- Jellyfin: 8096
- qBittorrent: 8080
- Samba, Syncthing: 8384
- Suwayomi: 4567
- FreshRSS: 18123
- Karakeep: 23001

```bash
cd media-stack && docker compose up -d
```

## syncthing
Runs on all Linux machines (laptops, mini PCs, desktops)
```bash
cd syncthing && docker compose up -d
```
UI: http://localhost:8384

## youtube-archivist
@ 192.168.100.195:8000
```bash
cd youtube-archivist && docker compose up -d
```

## openwrt
Config backups from EQI12 Proxmox VM (connect via `qc`)
