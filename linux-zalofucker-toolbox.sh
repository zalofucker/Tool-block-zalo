#!/bin/bash
CYAN='\033[0;36m'     
BLUE='\033[0;34m'      
BRIGHT_BLUE='\033[1;34m' 
LIGHT_CYAN='\033[1;36m'  
NC='\033[0m' 
HOSTS_FILE="/etc/hosts"
BACKUP_FILE="/etc/hosts.backup"
TEMP_DIR="/tmp/linux-zalofucker-toolbox"
ZALO_FILTER_URL="https://raw.githubusercontent.com/zalofucker/fuck-you-zalo/refs/heads/main/adaway.txt"
ZALOPAY_FILTER_URL="https://raw.githubusercontent.com/zalofucker/fuck-you-zalopay/refs/heads/main/adaway.txt"
ZINGMP3_FILTER_URL="https://raw.githubusercontent.com/zalofucker/fuck-you-zingmp3/refs/heads/main/adaway.txt"
KIKI_FILTER_URL="https://raw.githubusercontent.com/zalofucker/fuck-you-kiki/refs/heads/main/adaway.txt"
LABANKEY_FILTER_URL="https://raw.githubusercontent.com/zalofucker/fuck-you-labankey/refs/heads/main/adaway.txt"
mkdir -p "$TEMP_DIR"

show_banner() {
    clear
    echo -e "${BRIGHT_BLUE}"
    echo "========================================================"
    echo "                     Zalofucker Toolbox "
    echo "========================================================"
    echo "Version 0.0.5"
    echo -e "${NC}"
}

show_menu() {
    echo -e "${CYAN}Chọn chức năng:${NC}"
    echo "1. Chặn Zalo"
    echo "2. Chặn ZaloPay"
    echo "3. Chặn ZingMP3"
    echo "4. Chặn Kiki"
    echo "5. Chặn Labankey"
    echo "6. Chặn TẤT CẢ"
    echo "7. Bỏ chặn (khôi phục hosts về mặc định)"
    echo "8. Mở file hosts"
    echo "9. Kiểm tra trạng thái chặn"
    echo "0. Thoát"
    echo ""
    echo -n "Nhập lựa chọn [0-9]: "
}

backup_hosts() {
    if [ ! -f "$BACKUP_FILE" ]; then
        echo -e "${CYAN}Đang sao lưu file hosts...${NC}"
        sudo cp "$HOSTS_FILE" "$BACKUP_FILE"
        if [ $? -eq 0 ]; then
            echo -e "${BRIGHT_BLUE}✓ Đã sao lưu file hosts${NC}"
        else
            echo -e "${BLUE}✗ Lỗi khi sao lưu file hosts${NC}"
            return 1
        fi
    fi
}

# Hàm mở trình duyệt tương thích Linux
open_url() {
    local url=$1
    if command -v xdg-open &> /dev/null; then
        xdg-open "$url" > /dev/null 2>&1
    elif command -v gnome-open &> /dev/null; then
        gnome-open "$url" > /dev/null 2>&1
    else
        echo -e "${BLUE}Không thể tự động mở trình duyệt. Vui lòng truy cập: $url${NC}"
    fi
}

download_filter() {
    local url=$1
    local name=$2
    local output_file="$TEMP_DIR/$name.txt"
    
    echo -e "${CYAN}Đang tải bộ lọc $name...${NC}"
    
    curl -s -f -o "$output_file" "$url"
    
    if [ $? -eq 0 ] && [ -s "$output_file" ]; then
        echo -e "${BRIGHT_BLUE}✓ Đã tải thành công bộ lọc $name${NC}"
        return 0
    else
        echo ""
        echo "========================================================"
        echo "             LỖI: KHÔNG THỂ TẢI FILE BỘ LỌC"
        echo "========================================================"
        echo ""
        echo "📋 NGUYÊN NHÂN CÓ THỂ:"
        echo "  1. Không có kết nối Internet"
        echo "  2. Máy chủ bị chặn hoặc không khả dụng"
        echo "  3. URL nguồn bị thay đổi hoặc không còn tồn tại"
        echo "  4. Firewall/Antivirus đang chặn tool"
        echo ""
        echo "🔧 HƯỚNG DẪN KHẮC PHỤC:"
        echo ""
        echo "  ► Bước 1: Kiểm tra kết nối Internet"
        echo "     - Mở trình duyệt và thử truy cập: https://githubstatus.com"
        echo "     - Hoặc ping: ping -c 3 1.1.1.1"
        echo ""
        echo "  ► Bước 2: Kiểm tra curl có hoạt động không"
        echo "     - Mở Terminal và gõ: curl --version"
        echo "     - Nếu lỗi, cài đặt curl: sudo apt install curl (Ubuntu/Debian) hoặc sudo yum install curl (CentOS)"
        echo ""
        echo "  ► Bước 4: Tắt tạm thời Firewall"
        echo "     - Nếu dùng UFW: sudo ufw disable"
        echo "     - Nếu dùng IPTables: sudo iptables -F"
        echo ""
        echo "  ► Bước 5: Liên hệ hỗ trợ"
        echo "     - Gửi mail đến: luxediro.madiheo@collector.org"
        echo "     - Tạo ticket trên Github: https://github.com/orgs/zalofucker/discussions"
        echo ""
        echo "========================================================"
        echo ""
        while true; do
            read -p "Bạn có muốn mở trang hỗ trợ trên Github? (Y/N): " choice
            case "$choice" in
                [Yy]* )
                    echo "Đang mở trang hỗ trợ..."
                    open_url "https://github.com/orgs/zalofucker/discussions"
                    return 1
                    ;;
                [Nn]* )
                    return 1
                    ;;
                * )
                    echo "Vui lòng chọn Y hoặc N"
                    ;;
            esac
        done
    fi
}

apply_filter() {
    local filter_file=$1
    local name=$2
    
    if [ ! -f "$filter_file" ]; then
        echo ""
        echo "========================================================"
        echo "           LỖI: KHÔNG TÌM THẤY FILE BỘ LỌC"
        echo "========================================================"
        echo "  ► Bước 1: Kiểm tra thư mục tạm"
        echo "     - Chạy lệnh: ls -la $TEMP_DIR"
        echo "     - Xem có file $name.txt không"
        echo ""
        echo "  ► Bước 2: Khởi động lại script"
        echo "     - Thoát script và chạy lại với quyền sudo: sudo ./linux-zalofucker-toolbox.sh"
        echo ""
        echo "  ► Bước 3: Liên hệ hỗ trợ"
        echo "     - Gửi mail đến: luxediro.madiheo@collector.org"
        echo "     - Tạo ticket trên Github: https://github.com/orgs/zalofucker/discussions"
        # ...
        while true; do
            read -p "Bạn có muốn mở trang hỗ trợ trên Github? (Y/N): " choice
            case "$choice" in
                [Yy]* )
                    echo "Đang mở trang hỗ trợ..."
                    open_url "https://github.com/orgs/zalofucker/discussions"
                    return 1
                    ;;
                [Nn]* )
                    return 1
                    ;;
                * )
                    echo "Vui lòng chọn Y hoặc N"
                    ;;
            esac
        done
    fi
    
    echo -e "${CYAN}Đang áp dụng filter $name vào hosts...${NC}"
    
    # Backup trước khi thay đổi
    backup_hosts
    
    # Thêm marker để dễ quản lý
    echo "" | sudo tee -a "$HOSTS_FILE" > /dev/null
    echo "# === $name FILTER - $(date) ===" | sudo tee -a "$HOSTS_FILE" > /dev/null
    
    # Thêm nội dung filter vào hosts
    sudo cat "$filter_file" | sudo tee -a "$HOSTS_FILE" > /dev/null
    
    if [ $? -eq 0 ]; then
        echo -e "${BRIGHT_BLUE}✓ Đã áp dụng filter $name${NC}"
    else
        echo ""
        echo "========================================================"
        echo "         LỖI: KHÔNG THỂ ÁP DỤNG BỘ LỌC VÀO HOSTS"
        echo "========================================================"
        echo ""
        echo "📋 NGUYÊN NHÂN CÓ THỂ:"
        echo "  1. Không có quyền sudo/root"
        echo "  2. File /etc/hosts bị khóa (immutable bit)"
        echo "  3. Dung lượng đĩa đầy"
        echo ""
        echo "🔧 HƯỚNG DẪN KHẮC PHỤC:"
        echo ""
        echo "  ► Bước 1: Kiểm tra quyền sudo"
        echo "     - Chạy script với sudo: sudo ./linux-zalofucker-toolbox.sh"
        echo ""
        echo "  ► Bước 2: Kiểm tra quyền file hosts"
        echo "     - Chạy lệnh: ls -l /etc/hosts"
        echo "     - Nếu có thuộc tính 'i' (immutable), chạy: sudo chattr -i /etc/hosts"
        echo ""
        echo "  ► Bước 3: Kiểm tra dung lượng đĩa"
        echo "     - Chạy lệnh: df -h"
        echo ""
        echo "  ► Bước 4: Liên hệ hỗ trợ"
        echo "     - Gửi mail đến: luxediro.mahideo@collector.org"
        echo "     - Tạo ticket: https://github.com/orgs/zalofucker/discussions"
        echo ""
        echo "========================================================"
        # ...
        while true; do
            read -p "Bạn có muốn mở trang hỗ trợ trên Github? (Y/N): " choice
            case "$choice" in
                [Yy]* )
                    echo "Đang mở trang hỗ trợ..."
                    open_url "https://github.com/orgs/zalofucker/discussions"
                    return 1
                    ;;
                [Nn]* )
                    return 1
                    ;;
                * )
                    echo "Vui lòng chọn Y hoặc N"
                    ;;
            esac
        done
    fi
}

block_website() {
    local url=$1
    local name=$2
    
    download_filter "$url" "$name"
    if [ $? -eq 0 ]; then
        apply_filter "$TEMP_DIR/$name.txt" "$name"
        return $?
    else
        return 1
    fi
}

report_error() {
    local message=$1
    local context=$2
    
        echo ""
        echo "========================================================"
        echo "             LỖI: KHÔNG THỂ TẢI FILE BỘ LỌC"
        echo "========================================================"
        echo ""
        echo "📋 NGUYÊN NHÂN CÓ THỂ:"
        echo "  1. Không có kết nối Internet"
        echo "  2. Máy chủ bị chặn hoặc không khả dụng"
        echo "  3. URL nguồn bị thay đổi hoặc không còn tồn tại"
        echo "  4. Firewall/Antivirus đang chặn tool"
        echo ""
        echo "🔧 HƯỚNG DẪN KHẮC PHỤC:"
        echo ""
        echo "  ► Bước 1: Kiểm tra kết nối Internet"
        echo "     - Mở trình duyệt và thử truy cập: https://githubstatus.com"
        echo "     - Hoặc ping: ping -c 3 1.1.1.1"
        echo ""
        echo "  ► Bước 2: Kiểm tra curl có hoạt động không"
        echo "     - Mở Terminal và gõ: curl --version"
        echo "     - Nếu lỗi, cài đặt curl: sudo apt install curl (Ubuntu/Debian) hoặc sudo yum install curl (CentOS)"
        echo ""
        echo "  ► Bước 4: Tắt tạm thời Firewall"
        echo "     - Nếu dùng UFW: sudo ufw disable"
        echo "     - Nếu dùng IPTables: sudo iptables -F"
        echo ""
        echo "  ► Bước 5: Liên hệ hỗ trợ"
        echo "     - Gửi mail đến: luxediro.madiheo@collector.org"
        echo "     - Tạo ticket trên Github: https://github.com/orgs/zalofucker/discussions"
        echo ""
        echo "========================================================"
        while true; do
         read -p "Bạn có muốn mở trang hỗ trợ trên Github? (Y/N): " choice
            case "$choice" in
                [Yy]* )
                    echo "Đang mở trang hỗ trợ..."
                    open_url "https://github.com/orgs/zalofucker/discussions"
                    return 1
                    ;;
                [Nn]* )
                    return 1
                    ;;
                * )
                    echo "Vui lòng chọn Y hoặc N"
                    ;;
            esac
        done
}

block_all() {
    echo -e "${BRIGHT_BLUE}=== CHẶN TẤT CẢ ===${NC}"
    
    local filters=("ZALO:$ZALO_FILTER_URL" "ZALOPAY:$ZALOPAY_FILTER_URL" "ZINGMP3:$ZINGMP3_FILTER_URL" "LABANKEY:$LABANKEY_FILTER_URL" "KIKI:$KIKI_FILTER_URL")
    local success_count=0
    local fail_count=0
    local combined_file="$TEMP_DIR/combined.txt"
  
    rm -f "$combined_file"
    touch "$combined_file"
    
  
    for filter in "${filters[@]}"; do
        IFS=':' read -r name url <<< "$filter"
        
        download_filter "$url" "$name"
        if [ $? -eq 0 ]; then
            cat "$TEMP_DIR/$name.txt" >> "$combined_file"
            echo "" >> "$combined_file"
            ((success_count++))
        else
            ((fail_count++))
            echo -e "${CYAN}⚠ Bỏ qua filter $name do lỗi tải${NC}"
        fi
    done
    
    if [ $success_count -eq 0 ]; then
        echo -e "${BLUE}✗ Không tải được filter nào. Hủy bỏ thao tác.${NC}"
        report_error "Không tải được filter nào"
        return 1
    fi
    
    echo -e "${BRIGHT_BLUE}Kết quả: $success_count thành công, $fail_count thất bại${NC}"
    
    if [ -s "$combined_file" ]; then
        apply_filter "$combined_file" "TẤT CẢ"
        return $?
    else
        echo -e "${BLUE}✗ File kết hợp rỗng${NC}"
        report_error "File kết hợp rỗng"
        return 1
    fi
}


restore_hosts() {
    if [ -f "$BACKUP_FILE" ]; then
        echo -e "${CYAN}Đang khôi phục file hosts...${NC}"
        sudo cp "$BACKUP_FILE" "$HOSTS_FILE"
        
        if [ $? -eq 0 ]; then
            echo -e "${BRIGHT_BLUE}✓ Đã khôi phục file hosts${NC}"
            
            # Flush DNS cache (Linux logic)
            if command -v systemd-resolve &> /dev/null; then
                sudo systemd-resolve --flush-caches > /dev/null 2>&1
            elif command -v resolvectl &> /dev/null; then
                sudo resolvectl flush-caches > /dev/null 2>&1
            else
                sudo service network-manager restart > /dev/null 2>&1 || true
            fi
            echo -e "${BRIGHT_BLUE}✓ Đã làm mới DNS cache${NC}"
        else
            echo -e "${BLUE}✗ Lỗi khi khôi phục file hosts${NC}"
        fi
    else
        echo -e "${BLUE}✗ Không tìm thấy file backup${NC}"
    fi
}


open_hosts() {
    echo -e "${CYAN}Đang mở file hosts bằng nano...${NC}"
    sudo nano "$HOSTS_FILE"
}

# Hàm kiểm tra ping
check_ping() {
    local domain=$1
    echo -e "${CYAN}Đang kiểm tra $domain...${NC}"
    
    # Ping với timeout 2 giây, chỉ 1 packet
    ping -c 1 -W 2 "$domain" > /dev/null 2>&1
    
    if [ $? -ne 0 ]; then
        echo -e "${BRIGHT_BLUE}✓ $domain đã bị chặn thành công (không phản hồi)${NC}"
        return 0
    else
        echo -e "${BLUE}✗ $domain vẫn phản hồi (chưa bị chặn)${NC}"
        echo -e "Bạn có thể thử chạy lại"
        echo -n "Bạn có muốn truy cập trang báo lỗi? (y/n): "
        read answer
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            open_url "https://github.com/orgs/zalofucker/discussions"
        fi
        return 1
    fi
}


check_status() {
    echo -e "${BRIGHT_BLUE}=== KIỂM TRA TRẠNG THÁI CHẶN ===${NC}"
    
    local domains=("zalo.me" "zalopay.vn" "zingmp3.vn" "labankey.com" "kiki.zalo.ai")
    
    for domain in "${domains[@]}"; do
        check_ping "$domain"
        echo ""
    done
}

check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        echo ""
        echo "========================================================"
        echo "           ⚠️  CẢNH BÁO: THIẾU QUYỀN SUDO"
        echo "========================================================"
        echo ""
        echo -n "Bạn có muốn cấp quyền sudo để tiếp tục? (y/n): "
        read answer
        
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            echo ""
            echo -e "${CYAN}Đang khởi động lại script với quyền sudo...${NC}"
            echo -e "${CYAN}Vui lòng nhập mật khẩu quản trị (nếu có):${NC}"
            echo ""

            sudo "$0" "$@"
            exit $?
        else
            echo ""
            echo -e "${BLUE}✗ Chịu.${NC}"
            echo ""
            echo "Mẹo (mày bé): Chạy script bằng lệnh:"
            echo "   sudo $0"
            echo ""
            exit 1
        fi
    fi
}

main() {
    if [ "$1" != "7" ]; then
        check_sudo "$@"
    fi
    
    while true; do
        show_banner
        show_menu
        read choice
        
        case $choice in
            1)
                block_website "$ZALO_FILTER_URL" "ZALO"
                ;;
            2)
                block_website "$ZALOPAY_FILTER_URL" "ZALOPAY"
                ;;
            3)
                block_website "$ZINGMP3_FILTER_URL" "ZINGMP3"
                ;;
            4)
                block_website "$KIKI_FILTER_URL" "KIKI"
                ;;
            5)
                block_website "$LABANKEY_FILTER_URL" "LABANKEY"
                ;;
            6)
                block_all
                ;;
            7)
                restore_hosts
                ;;
            8)
                open_hosts
                ;;
            9)
                check_status
                ;;
            0)
                echo -e "${BRIGHT_BLUE}Tạm biệt!${NC}"
                echo -e "${BRIGHT_BLUE}Fuck you Zalo${NC}"
                exit 0
                ;;
            *)
                echo -e "${BLUE}Lựa chọn không hợp lệ!${NC}"
                ;;
        esac
        
        echo ""
        echo -n "Nhấn Enter để tiếp tục..."
        read
    done
}
main "$@"
