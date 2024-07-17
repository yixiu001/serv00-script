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
    echo -e "--------------------------------------------------------------------------------------------------"
}


# Function to generate a UUID
generate_uuid() {
    for i in {1..3}; do
        uuid=$(uuidgen)
        if [[ -n "$uuid" ]]; then
            echo "$uuid"
            return
        fi
    done

    # 预定义的UUID列表
    predefined_uuids=(
        "fb210b24-46dd-4b4c-92ce-097385945dad"
        "53cfcb07-8c25-4c25-baaa-95b4b50871a2"
        "445ae56f-727d-495e-9c88-cbe942d144a6"
        "078eb39d-2094-4272-b221-782ba0520dd6"
        "5826e9cc-c5b7-49ca-8b37-a0ea68f382cc"
        "e79fda4a-9519-4ef3-8973-130801b3d0ae"
        "c0422b3b-00aa-4dbe-8573-6fb15d49e557"
        "907e3ac9-02de-47fe-b40c-c2bd912c3adf"
        "c53ca34c-8d9c-4a7e-8b44-5da52e4b5eaa"
        "73fc0a2d-2458-435b-92aa-b4e8e3e40944"
    )
    uuid=${predefined_uuids[$RANDOM % ${#predefined_uuids[@]}]}
    echo "$uuid"
}
# Function to save config.json
save_config() {
    local port=$1
    if [[ ! -f ~/domains/$USER.serv00.net/vless/config.json ]]; then
        uuid=$(generate_uuid)
        cat <<EOL > ~/domains/$USER.serv00.net/vless/config.json
{
    "uuid": "$uuid",
    "port": $port
}
EOL
        echo "生成config.json文件。"
    else
        # Update the port in config.json if it exists
        jq --arg port "$port" '.port = ($port | tonumber)' ~/domains/$USER.serv00.net/vless/config.json > ~/domains/$USER.serv00.net/vless/config_tmp.json && mv ~/domains/$USER.serv00.net/vless/config_tmp.json ~/domains/$USER.serv00.net/vless/config.json
        echo "config.json文件已存在，端口号已更新。"
    fi
}

# Function to deploy vless
deploy_vless() {
    local port=${1:-3000}  # Default port is 3000 if not provided
    # 修改端口号
    save_config "$port"
    # 安装依赖
    npm install
    # 启动vless项目
    ~/.npm-global/bin/pm2 start ~/domains/$USER.serv00.net/vless/app.js --name vless
    # 保存pm2进程状态
    ~/.npm-global/bin/pm2 save
    # ANSI颜色码
    output_yi_xiu
    echo -e "端口号: ${GREEN}${port}${NC}"
    echo -e "UUID: ${GREEN}${uuid}${NC}"
    echo -e "域名: ${GREEN}$USER.serv00.net${NC}"
    echo -e "vless进程维护定时任务脚本: ${GREEN}cd ~/domains/$USER.serv00.net/vless && ./check_vless.sh${NC}"
    echo -e "VLESS节点信息: ${GREEN}vless://${uuid}@$USER.serv00.net:${port}?flow=&security=none&encryption=none&type=ws&host=$USER.serv00.net&path=/&sni=&fp=&pbk=&sid=#$USER.serv00.vless${NC}"
}

# 启动pm2 vless进程
start_pm2_vless_process() {
    echo "正在启动pm2 vless进程..."
    ~/.npm-global/bin/pm2 start ~/domains/$USER.serv00.net/vless/app.js --name vless
    echo -e "${GREEN}pm2 vless进程已启动。${NC}"
}
# 检查vless的状态
check_vless_status() {
    status=$(pm2 status vless | grep -w 'vless' | awk '{print $18}')
    if [[ "$status" == "online" ]]; then
        echo "vless进程正在运行。"
    else
        echo "vless进程未运行或已停止，正在重启..."
        pm2 restart vless
        echo -e "${GREEN}vless进程已重启。${NC}"
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
# 主函数
main() {
    local port=3000  # Default port
    port_provided=false  # Flag to check if port is provided

    while getopts ":p:" opt; do
        case $opt in
            p)
                port=$OPTARG
                port_provided=true
                ;;
            *)
                echo "无效参数"; exit 1 ;;
        esac
    done
    shift $((OPTIND -1))

    if [ "$port_provided" = true ]; then
        echo "正在安装vless..."
        deploy_vless "$port"
    else
        echo "没有提供-p参数，跳过vless安装。"
        # 读取 config.json 中的 uuid 和 port
        if [[ -f config.json ]]; then
            uuid=$(jq -r '.uuid' config.json)
            port=$(jq -r '.port' config.json)
            echo -e "UUID: ${uuid}"
            echo -e "Port: ${port}"
            echo -e "域名: $USER.serv00.net"
            echo -e "VLESS节点信息: vless://${uuid}@$USER.serv00.net:${port}?flow=&security=none&encryption=none&type=ws&host=$USER.serv00.net&path=/&sni=&fp=&pbk=&sid=#$USER.serv00.vless"

        else
            echo -e "config.json 文件不存在或格式错误。"
        fi
        echo "开始检查pm2 vless进程..."
        check_pm2_vless_status
    fi


}

# 执行主函数
main "$@"
