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



# Function to deploy vless
deploy_vless() {
    # 赋予vless维护脚本权限
    chmod +x ./vless/check_vless.sh
    # 安装依赖
    npm install --prefix ./vless
    # 进入工作目录
    cp -r ./vless ~/domains/$USER.serv00.net
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
echo -e "请执行以下脚本:${GREEN}cd ~/domains/$USER.serv00.net/vless && ./check_vless.sh -p 17061${NC}"
}

# Main function
main() {
    echo "正在安装pm2..."
    install_pm2
    echo "正在部署vless到指定目录..."
    deploy_vless
}

# 执行主函数
main "$@"

