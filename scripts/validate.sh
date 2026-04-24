#!/bin/bash
exec > >(tee /var/log/codedeploy-validate.log) 2>&1
echo "=== ValidateService ==="

# Wait for app to be ready
sleep 10

# Check if app is responding on port 8000
curl -f http://localhost:8000/api/health

if [ $? -eq 0 ]; then
  echo "✅ Health check passed - deployment successful"
  exit 0
else
  echo "❌ Health check failed - deployment failed"
  exit 1
fi