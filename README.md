# Setting Ubuntu Server

```bash
curl -fsSL https://raw.githubusercontent.com/takeedev/setting-ubuntu-server/refs/heads/main/install.sh | /usr/bin/env bash
```

สคริปต์จะติดตั้ง UFW แต่จะยังไม่เปิด firewall อัตโนมัติ เพื่อป้องกันการตัดการเชื่อมต่อ SSH
หากต้องการตั้งค่า default rules, อนุญาต OpenSSH และเปิด UFW:

```bash
curl -fsSL https://raw.githubusercontent.com/takeedev/setting-ubuntu-server/refs/heads/main/install.sh | /usr/bin/env bash -s -- --enable-ufw
```

## สิ่งที่สคริปต์ติดตั้ง

- Docker Engine
- Docker CLI
- containerd
- Docker Buildx plugin
- Docker Compose plugin
- UFW
