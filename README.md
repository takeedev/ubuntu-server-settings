# Setting Ubuntu Server

สคริปต์สำหรับติดตั้ง Docker Engine และ UFW บน Ubuntu Server แบบรันซ้ำได้
หากตรวจพบว่าติดตั้งโปรแกรมไว้แล้ว สคริปต์จะข้ามการติดตั้งโปรแกรมนั้น

## ติดตั้ง

เรียกใช้โดยตรงจาก GitHub:

```bash
curl -fsSL https://raw.githubusercontent.com/takeedev/setting-ubuntu-server/refs/heads/main/install.sh | /usr/bin/env bash
```

สคริปต์จะติดตั้ง UFW แต่จะยังไม่เปิด firewall อัตโนมัติ เพื่อป้องกันการตัดการเชื่อมต่อ SSH

หากต้องการตั้งค่า default rules, อนุญาต OpenSSH และเปิด UFW:

```bash
curl -fsSL https://raw.githubusercontent.com/takeedev/setting-ubuntu-server/refs/heads/main/install.sh | /usr/bin/env bash -s -- --enable-ufw
```

> ก่อนเปิด UFW ควรตรวจสอบว่าเซิร์ฟเวอร์ใช้ SSH port มาตรฐานที่รองรับโดย profile `OpenSSH`
> หากใช้ port อื่น ให้เพิ่ม rule ของ port นั้นก่อนเปิด UFW

## ติดตั้งจากไฟล์

```bash
git clone https://github.com/takeedev/setting-ubuntu-server.git
cd setting-ubuntu-server
./install.sh
```

ดูตัวเลือกทั้งหมด:

```bash
./install.sh --help
```

## สิ่งที่สคริปต์ติดตั้ง

- Docker Engine
- Docker CLI
- containerd
- Docker Buildx plugin
- Docker Compose plugin
- UFW

รองรับ Ubuntu เท่านั้น

## License

[MIT](LICENSE)
