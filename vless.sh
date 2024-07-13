#!/bin/bash

# Function to check if pm2 is installed
check_pm2_installed() {
    if command -v pm2 &>/dev/null; then
        return 0  # pm2已安装
    else
        return 1  # pm2未安装
    fi
}

# Function to install pm2
install_pm2() {
    if ! check_pm2_installed; then
        curl -s https://raw.githubusercontent.com/k0baya/alist_repl/main/serv00/install-pm2.sh | bash
        echo "pm2安装成功。"
    else
        echo "pm2已经安装。"
    fi
}

# Function to save config.json
save_config() {
    local port=$1
    if [[ ! -f ./vless/config.json ]]; then
        uuid=$(uuidgen)
        cat <<EOL > ./vless/config.json
{
    "uuid": "$uuid",
    "port": $port
}
EOL
        echo "生成./vless/config.json文件。"
    else
        # Update the port in config.json if it exists
        jq --arg port "$port" '.port = ($port | tonumber)' ./vless/config.json > ./vless/config_tmp.json && mv ./vless/config_tmp.json ./vless/config.json
        echo "./vless/config.json文件已存在，端口号已更新。"
    fi
}

# Function to deploy vless
deploy_vless() {
    local port=${1:-3000}  # Default port is 3000 if not provided

    save_config "$port"

    cp -r ./vless ~/domains/$USER.serv00.net

    ~/.npm-global/bin/pm2 start ~/domains/$USER.serv00.net/vless/app.js --name vless

# ANSI颜色码
GREEN='\033[0;32m'
NC='\033[0m'  # 恢复默认颜色

# 输出绿色的 "YI XIU"
echo -e "${GREEN} .----------------.  .----------------.  .----------------.  .----------------.  .----------------. "
echo -e "| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |"
echo -e "| |  ____  ____  | || |     _____    | || |  ____  ____  | || |     _____    | || | _____  _____ | |"
echo -e "| | |_  _||_  _| | || |    |_   _|   | || | |_  _||_  _| | || |    |_   _|   | || ||_   _||_   _|| |"
echo -e "| |   \\ \\  / /   | || |      | |     | || |   \\ \\  / /   | || |      | |     | || |  | |    | |  | |"
echo -e "| |    \\ \\/ /    | || |      | |     | || |    > \`' <    | || |      | |     | || |  | '    ' |  | |"
echo -e "| |    _|  |_    | || |     _| |_    | || |  _/ /'\\ \\_  | || |     _| |_    | || |   \\ \`--' /   | |"
echo -e "| |   |______|   | || |    |_____|   | || | |____||____| | || |    |_____|   | || |    \`.__.'    | |"
echo -e "| |              | || |              | || |              | || |              | || |              | |"
echo -e "| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |"
echo -e " '----------------'  '----------------'  '----------------'  '----------------'  '----------------' ${NC}"


# 输出端口号和UUID以及vless节点
echo -e "${GREEN}端口号: ${port}${NC}"
echo -e "${GREEN}UUID: ${uuid}${NC}"
echo -e "${GREEN}域名: $USER.serv00.net${NC}"
echo -e "${GREEN}VLESS: vless://${uuid}@$USER.serv00.net:${port}?flow=&security=none&encryption=none&type=ws&host=$USER.serv00.net&path=/&sni=&fp=&pbk=&sid=#%E4%B8%80%E4%BC%91vless%EF%BC%8CTG%E7%BE%A4%EF%BC%9Ahttps://t.me/yxjsjl${NC}"
}

# Main function
main() {
    local port=3000  # Default port

    while getopts "p:" opt; do
        case $opt in
            p) port=$OPTARG ;;
            *) echo "无效参数"; exit 1 ;;
        esac
    done
    shift $((OPTIND -1))

    echo "正在安装pm2..."
    install_pm2
    echo "正在安装vless..."
    deploy_vless "$port"
}

# 执行主函数
main "$@"

