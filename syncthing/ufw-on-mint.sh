#!/usr/bin/env bash
sudo ufw allow 8384/tcp    # Web UI
sudo ufw allow 22000/tcp   # TCP sync
sudo ufw allow 22000/udp   # QUIC
sudo ufw allow 21027/udp   # local discovery
