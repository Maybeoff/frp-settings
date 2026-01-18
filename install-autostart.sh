#!/bin/bash

echo "Установка FRP в автозапуск..."

# Проверяем права root
if [ "$EUID" -ne 0 ]; then
    echo "Ошибка: запустите скрипт с правами root (sudo)"
    exit 1
fi

# Создаем директории
echo "Создаем директории..."
mkdir -p /usr/local/bin
mkdir -p /usr/local/etc/frp
mkdir -p /var/log/frp

# Копируем исполняемые файлы
echo "Копируем исполняемые файлы..."
cp ./frps /usr/local/bin/
cp ./frpc /usr/local/bin/
chmod +x /usr/local/bin/frps
chmod +x /usr/local/bin/frpc

# Копируем конфигурационные файлы
echo "Копируем конфигурации..."
cp ./frps.toml /usr/local/etc/frp/
cp ./frpc.toml /usr/local/etc/frp/

# Обновляем пути к логам в конфигурациях
sed -i 's|log.to = "./frps.log"|log.to = "/var/log/frp/frps.log"|g' /usr/local/etc/frp/frps.toml
sed -i 's|log.to = "./frpc.log"|log.to = "/var/log/frp/frpc.log"|g' /usr/local/etc/frp/frpc.toml

# Копируем systemd сервисы
echo "Устанавливаем systemd сервисы..."
cp ./frps.service /etc/systemd/system/
cp ./frpc.service /etc/systemd/system/

# Перезагружаем systemd
echo "Перезагружаем systemd..."
systemctl daemon-reload

# Включаем автозапуск
echo "Включаем автозапуск сервисов..."
systemctl enable frps.service
systemctl enable frpc.service

echo ""
echo "✅ Установка завершена!"
echo ""
echo "Управление сервисами:"
echo "  Запуск сервера:    sudo systemctl start frps"
echo "  Остановка сервера: sudo systemctl stop frps"
echo "  Статус сервера:    sudo systemctl status frps"
echo ""
echo "  Запуск клиента:    sudo systemctl start frpc"
echo "  Остановка клиента: sudo systemctl stop frpc"
echo "  Статус клиента:    sudo systemctl status frpc"
echo ""
echo "Логи:"
echo "  Сервер: /var/log/frp/frps.log"
echo "  Клиент: /var/log/frp/frpc.log"
echo "  Системные логи: journalctl -u frps -f"
echo "                  journalctl -u frpc -f"
echo ""
echo "Автозапуск включен. Сервисы запустятся при следующей перезагрузке."
echo "Для немедленного запуска выполните:"
echo "  sudo systemctl start frps"
echo "  sudo systemctl start frpc"