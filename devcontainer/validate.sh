#!/usr/bin/env bash

set -Eeuo pipefail

node_major=$(node --version | cut -d. -f1 | tr -d 'v')
if [[ "$node_major" != '18' ]]; then
  echo "Expected Node.js 18, found $(node --version)." >&2
  exit 1
fi

echo 'Installing Ansible Galaxy dependencies...'
ansible-galaxy install -r requirements.yml

echo 'Checking Ansible syntax...'
ansible-playbook --syntax-check -i inventories/sample/inventory nas-reorder.yml

echo 'Running Ansible lint...'
ansible-lint nas-reorder.yml

echo 'Running YAML lint...'
yamllint .

echo 'Running Markdown lint...'
markdownlint '**/*.md'

echo 'Building the documentation website...'
(cd website && npm ci && npm run build)

echo 'Running Molecule role tests against the host Docker daemon...'
./tests/test.sh
