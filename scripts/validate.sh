#!/bin/bash
sleep 5
curl -f http://localhost:8000/api/health || exit 1
echo "Health check passed"
