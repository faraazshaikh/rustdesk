#!/usr/bin/env bash
# Rebrand the client and point it at your own server. Idempotent; run from the repo root
# after `git submodule update --init libs/hbb_common`, before building.
# Usage: SERVER_KEY=<contents of id_ed25519.pub> deploy/apply-branding.sh
set -euo pipefail
APP_NAME="${APP_NAME:-IntelisenseDesk}"
SERVER_HOST="${SERVER_HOST:-desk.intellisenselabs.com}"
: "${SERVER_KEY:?set SERVER_KEY to the public key from the server data/id_ed25519.pub}"

cfg=libs/hbb_common/src/config.rs
sed -i.bak -E '/pub static ref APP_NAME/ s|RwLock::new\("[^"]*"|RwLock::new("'"${APP_NAME}"'"|' "$cfg"
sed -i.bak -E 's|^pub const RENDEZVOUS_SERVERS: .*|pub const RENDEZVOUS_SERVERS: \&[\&str] = \&["'"${SERVER_HOST}"'"];|' "$cfg"
sed -i.bak -E 's|^pub const RS_PUB_KEY: .*|pub const RS_PUB_KEY: \&str = "'"${SERVER_KEY}"'";|' "$cfg"

sed -i.bak -E 's|^ProductName = ".*"|ProductName = "'"${APP_NAME}"'"|; s|^description = ".*"|description = "'"${APP_NAME}"' Remote Desktop"|' Cargo.toml
sed -i.bak -E '/^\[package.metadata.bundle\]/,/^\[/ s|^name = ".*"|name = "'"${APP_NAME}"'"|' Cargo.toml
rm -f "$cfg.bak" Cargo.toml.bak
echo "Branded as ${APP_NAME} -> ${SERVER_HOST}"
