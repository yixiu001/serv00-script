#!/bin/bash

# ANSI颜色码
GREEN='\033[0;32m'
NC='\033[0m'  # 恢复默认颜色

# 输出绿色的 "YI XIU"
output_yi_xiu() {
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
}

# 检查pm2 vless的状态
check_pm2_vless_status() {
    pm2 describe vless &>/dev/null
    if [[ $? -eq 0 ]]; then
        check_vless_status
    else
        echo "未找到pm2 vless进程，检查是否有快照..."
        check_pm2_vless_snapshot
    fi
}

# 检查是否有pm2 vless快照
check_pm2_vless_snapshot() {
    if [[ -f ~/.pm2/dump.pm2 ]]; then
        echo "检测到pm2 vless快照，正在恢复..."
        pm2 resurrect
        echo -e "${GREEN}pm2 vless快照已恢复。${NC}"
        check_vless_status
    else
        echo "未检测到pm2 vless快照，启动vless进程..."
        start_pm2_vless_process
    fi
}

# 启动pm2 vless进程
start_pm2_vless_process() {
    echo "正在启动pm2 vless进程..."
    ~/.npm-global/bin/pm2 start ~/domains/$USER.serv00.net/vless/app.js --name vless
    echo -e "${GREEN}pm2 vless进程已启动。${NC}"
}

# 检查vless的状态
check_vless_status() {
    status=$(pm2 status vless | grep -w 'vless' | awk '{print $12}')
    if [[ "$status" == "online" ]]; then
        echo "vless进程正在运行。"
    else
        echo "vless进程未运行或已停止，正在重启..."
        pm2 restart vless
        echo -e "${GREEN}vless进程已重启。${NC}"
    fi
}

# 主函数
main() {
    output_yi_xiu
    echo "开始检查pm2 vless进程..."
    check_pm2_vless_status
}

# 执行主函数
main
