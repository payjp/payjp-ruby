#!/bin/sh

set +x
mkdir -p ~/.gem

cat << EOF > ~/.gem/credentials
---
:rubygems_api_key: ${RUBYGEMS_API_KEY}
EOF

chmod 0600 ~/.gem/credentials
set -x

echo "Building gem and publish to rubygems."
bundle exec rake release
