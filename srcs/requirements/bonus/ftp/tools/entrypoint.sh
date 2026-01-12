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

cleanup() {
    echo "[FTP] Received shutdown signal, stopping vsftpd"
    kill -TERM "$VSFTPD_PID" 2>/dev/null || true
    wait "$VSFTPD_PID" 2>/dev/null || true
    echo "[FTP] Service stopped"
    exit 0
}

trap cleanup TERM INT QUIT

echo "[FTP] Starting vsftpd server..."
vsftpd /etc/vsftpd/vsftpd.conf &
VSFTPD_PID=$!

wait "$VSFTPD_PID"

echo "[FTP] vsftpd process ended"
exit 0
