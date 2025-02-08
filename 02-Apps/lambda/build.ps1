$ErrorActionPreference = "Stop"

# Run npm clean, build, and zip commands sequentially
npm install && npm run clean && npm run build && npm run zip
