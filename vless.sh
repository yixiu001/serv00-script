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
    # 修改端口号
    save_config "$port"
    # 赋予vless维护脚本权限
    chmod +x ./vless/check_vless.sh
    # 安装依赖
    npm install --prefix ./vless
    # 进入工作目录
    cp -r ./vless ~/domains/$USER.serv00.net
    # 启动vless项目
    ~/.npm-global/bin/pm2 start ~/domains/$USER.serv00.net/vless/app.js --name vless
    # 保存pm2进程状态
    ~/.npm-global/bin/pm2 save
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
echo -e "--------------------------------------------------------------------------------------------------"
echo -e "一休YouTuBe: ${GREEN}https://www.youtube.com/@yixiu001${NC}"
echo -e "TG技术交流群: ${GREEN}https://t.me/yxjsjl${NC}"
echo -e "--------------------------------------------------------------------------------------------------"
echo -e "端口号: ${GREEN}${port}${NC}"
echo -e "UUID: ${GREEN}${uuid}${NC}"
echo -e "域名: ${GREEN}$USER.serv00.net${NC}"
echo -e "vless进程维护定时任务脚本: ${GREEN}~/domains/$USER.serv00.net/vless/check_vless.sh${NC}"
echo -e "VLESS节点信息: ${GREEN}vless://${uuid}@$USER.serv00.net:${port}?flow=&security=none&encryption=none&type=ws&host=$USER.serv00.net&path=/&sni=&fp=&pbk=&sid=#$USER.serv00.vless${NC}"
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

