#!/bin/bash

echo "Удаление FRP из автозапуска..."

# Проверяем права root
if [ "$EUID" -ne 0 ]; then
    echo "Ошибка: запустите скрипт с правами root (sudo)"
    exit 1
fi

# Останавливаем сервисы
echo "Останавливаем сервисы..."
systemctl stop frps.service 2>/dev/null
systemctl stop frpc.service 2>/dev/null

# Отключаем автозапуск
echo "Отключаем автозапуск..."
systemctl disable frps.service 2>/dev/null
systemctl disable frpc.service 2>/dev/null

# Удаляем systemd сервисы
echo "Удаляем systemd сервисы..."
rm -f /etc/systemd/system/frps.service
rm -f /etc/systemd/system/frpc.service

# Перезагружаем systemd
echo "Перезагружаем systemd..."
systemctl daemon-reload

# Удаляем файлы (опционально)
read -p "Удалить установленные файлы? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Удаляем файлы..."
    rm -f /usr/local/bin/frps
    rm -f /usr/local/bin/frpc
    rm -rf /usr/local/etc/frp
    rm -rf /var/log/frp
    echo "Файлы удалены."
else
    echo "Файлы оставлены в системе."
fi

echo ""
echo "✅ Удаление завершено!"
echo "FRP больше не будет запускаться автоматически."