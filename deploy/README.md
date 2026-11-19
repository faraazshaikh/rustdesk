# Server deployment

1. Open firewall ports: TCP 21115-21119, UDP 21116.
2. `RELAY_HOST=your.domain.com docker compose up -d`
3. Read `data/id_ed25519.pub`: this is the key clients need.
4. Build clients with your server and key as defaults (see top-level branding notes).

`-k _` makes the server reject clients that do not hold your key.
