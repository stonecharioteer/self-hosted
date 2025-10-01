#!/usr/bin/env bash

echo 'fs.inotify.max_user_watches=1048576' | sudo tee /etc/sysctl.d/99-syncthing.conf
echo 'fs.inotify.max_user_instances=1024'  | sudo tee -a /etc/sysctl.d/99-syncthing.conf
sudo sysctl --system
