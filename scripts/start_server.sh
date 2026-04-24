#!/bin/bash
cd /opt/campusarena/server
pm2 restart campusarena-backend || pm2 start npm --name "campusarena-backend" -- start
pm2 startup systemd -u root --hp /root
pm2 save
echo "Server started"
