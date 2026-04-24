#!/bin/bash
exec > >(tee /var/log/codedeploy-before-install.log) 2>&1
echo "=== BeforeInstall ==="

# Stop existing app if running
if pm2 list | grep -q "campusarena-backend"; then
  pm2 stop campusarena-backend
  pm2 delete campusarena-backend
  echo "Stopped existing PM2 process"
fi

# Backup existing uploads directory so it's not wiped
if [ -d /opt/campusarena/server/uploads ]; then
  cp -r /opt/campusarena/server/uploads /tmp/campusarena-uploads-backup
  echo "Backed up uploads directory"
fi

echo "BeforeInstall complete"