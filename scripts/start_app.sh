#!/bin/bash
exec > >(tee /var/log/codedeploy-start-app.log) 2>&1
echo "=== ApplicationStart ==="

cd /opt/campusarena/server

# Start with PM2
pm2 start npm --name "campusarena-backend" -- start
pm2 save

echo "ApplicationStart complete"