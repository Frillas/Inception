#!/bin/sh
set -e

FTP_USER=$(echo "$USERS" | cut -d'|' -f1)
FTP_PASS=$(echo "$USERS" | cut -d'|' -f2)
FTP_UID=$(echo "$USERS" | cut -d'|' -f3)
FTP_GID=$(echo "$USERS" | cut -d'|' -f4)

if ! getent group "$FTP_USER" >/dev/null 2>&1; then
    addgroup -g "$FTP_GID" "$FTP_USER"
fi

if ! id "$FTP_USER" >/dev/null 2>&1; then
    adduser -D -u "$FTP_UID" -G "$FTP_USER" "$FTP_USER"
    echo "$FTP_USER:$FTP_PASS" | chpasswd
fi

mkdir -p "/home/$FTP_USER"
chown -R "$FTP_USER:$FTP_USER" "/home/$FTP_USER"

echo "[FTP] User $FTP_USER created"
echo "[FTP] Starting vsftpd server..."

exec vsftpd /etc/vsftpd/vsftpd.conf
