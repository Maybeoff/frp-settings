#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

show_status() {
    echo -e "${BLUE}=== Статус FRP сервисов ===${NC}"
    echo ""
    
    echo -e "${YELLOW}FRP Server:${NC}"
    systemctl is-active --quiet frps && echo -e "  Статус: ${GREEN}Запущен${NC}" || echo -e "  Статус: ${RED}Остановлен${NC}"
    systemctl is-enabled --quiet frps && echo -e "  Автозапуск: ${GREEN}Включен${NC}" || echo -e "  Автозапуск: ${RED}Отключен${NC}"
    
    echo ""
    echo -e "${YELLOW}FRP Client:${NC}"
    systemctl is-active --quiet frpc && echo -e "  Статус: ${GREEN}Запущен${NC}" || echo -e "  Статус: ${RED}Остановлен${NC}"
    systemctl is-enabled --quiet frpc && echo -e "  Автозапуск: ${GREEN}Включен${NC}" || echo -e "  Автозапуск: ${RED}Отключен${NC}"
    echo ""
}

show_menu() {
    echo -e "${BLUE}=== Управление FRP ===${NC}"
    echo ""
    echo "1) Показать статус"
    echo "2) Запустить сервер"
    echo "3) Остановить сервер"
    echo "4) Перезапустить сервер"
    echo "5) Запустить клиент"
    echo "6) Остановить клиент"
    echo "7) Перезапустить клиент"
    echo "8) Показать логи сервера"
    echo "9) Показать логи клиента"
    echo "10) Показать системные логи сервера"
    echo "11) Показать системные логи клиента"
    echo "0) Выход"
    echo ""
}

while true; do
    show_menu
    read -p "Выберите действие: " choice
    
    case $choice in
        1)
            show_status
            ;;
        2)
            echo "Запускаем FRP сервер..."
            sudo systemctl start frps
            systemctl is-active --quiet frps && echo -e "${GREEN}Сервер запущен${NC}" || echo -e "${RED}Ошибка запуска сервера${NC}"
            ;;
        3)
            echo "Останавливаем FRP сервер..."
            sudo systemctl stop frps
            echo -e "${YELLOW}Сервер остановлен${NC}"
            ;;
        4)
            echo "Перезапускаем FRP сервер..."
            sudo systemctl restart frps
            systemctl is-active --quiet frps && echo -e "${GREEN}Сервер перезапущен${NC}" || echo -e "${RED}Ошибка перезапуска сервера${NC}"
            ;;
        5)
            echo "Запускаем FRP клиент..."
            sudo systemctl start frpc
            systemctl is-active --quiet frpc && echo -e "${GREEN}Клиент запущен${NC}" || echo -e "${RED}Ошибка запуска клиента${NC}"
            ;;
        6)
            echo "Останавливаем FRP клиент..."
            sudo systemctl stop frpc
            echo -e "${YELLOW}Клиент остановлен${NC}"
            ;;
        7)
            echo "Перезапускаем FRP клиент..."
            sudo systemctl restart frpc
            systemctl is-active --quiet frpc && echo -e "${GREEN}Клиент перезапущен${NC}" || echo -e "${RED}Ошибка перезапуска клиента${NC}"
            ;;
        8)
            echo -e "${BLUE}=== Логи FRP сервера ===${NC}"
            tail -f /var/log/frp/frps.log 2>/dev/null || echo "Файл лога не найден"
            ;;
        9)
            echo -e "${BLUE}=== Логи FRP клиента ===${NC}"
            tail -f /var/log/frp/frpc.log 2>/dev/null || echo "Файл лога не найден"
            ;;
        10)
            echo -e "${BLUE}=== Системные логи FRP сервера ===${NC}"
            journalctl -u frps -f
            ;;
        11)
            echo -e "${BLUE}=== Системные логи FRP клиента ===${NC}"
            journalctl -u frpc -f
            ;;
        0)
            echo "Выход..."
            exit 0
            ;;
        *)
            echo -e "${RED}Неверный выбор. Попробуйте снова.${NC}"
            ;;
    esac
    
    echo ""
    read -p "Нажмите Enter для продолжения..."
    clear
done