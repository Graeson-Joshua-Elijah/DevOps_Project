#!/bin/bash
set -e
echo "🔧 Installing dependencies..."
pip install -r app/requirements.txt
echo "🧪 Running tests..."
pytest app/src
echo "✅ Build and test completed successfully!"
