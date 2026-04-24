#!/bin/bash
exec > >(tee /var/log/codedeploy-after-install.log) 2>&1
echo "=== AfterInstall ==="

cd /opt/campusarena/server

# Restore uploads directory
if [ -d /tmp/campusarena-uploads-backup ]; then
  cp -r /tmp/campusarena-uploads-backup/* /opt/campusarena/server/uploads/ 2>/dev/null || true
  echo "Restored uploads directory"
fi

# Create uploads dir if it doesn't exist
mkdir -p /opt/campusarena/server/uploads
chmod 755 /opt/campusarena/server/uploads

# Write .env file from SSM Parameter Store
aws ssm get-parameter --name /campusarena/MONGODB_URI --with-decryption \
  --query Parameter.Value --output text --region ap-south-1 > /tmp/mongo_uri

cat > /opt/campusarena/server/.env << ENVEOF
MONGODB_URI=$(cat /tmp/mongo_uri)
JWT_SECRET=$(aws ssm get-parameter --name /campusarena/JWT_SECRET --with-decryption --query Parameter.Value --output text --region ap-south-1)
PORT=8000
NODE_ENV=production
FRONTEND_URL=$(aws ssm get-parameter --name /campusarena/FRONTEND_URL --query Parameter.Value --output text --region ap-south-1)
DEFAULT_ADMIN_PASSWORD=$(aws ssm get-parameter --name /campusarena/DEFAULT_ADMIN_PASSWORD --with-decryption --query Parameter.Value --output text --region ap-south-1)
STRIPE_PUBLISHABLE_KEY=$(aws ssm get-parameter --name /campusarena/STRIPE_PUBLISHABLE_KEY --with-decryption --query Parameter.Value --output text --region ap-south-1)
STRIPE_SECRET_KEY=$(aws ssm get-parameter --name /campusarena/STRIPE_SECRET_KEY --with-decryption --query Parameter.Value --output text --region ap-south-1)
MAX_FILE_SIZE=5242880
UPLOAD_PATH=./uploads
AWS_S3_BUCKET=production-campusarena-uploads-015986344124
AWS_REGION=ap-south-1
ENVEOF

chmod 600 /opt/campusarena/server/.env
rm /tmp/mongo_uri

# Install dependencies
npm install --production

echo "AfterInstall complete"