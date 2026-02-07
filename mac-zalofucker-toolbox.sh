#!/bin/bash
CYAN='\033[0;36m'     
BLUE='\033[0;34m'      
BRIGHT_BLUE='\033[1;34m' 
LIGHT_CYAN='\033[1;36m'  
NC='\033[0m' 
HOSTS_FILE="/etc/hosts"
BACKUP_FILE="/etc/hosts.backup"
TEMP_DIR="/tmp/website_blocker"
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
    echo "           Zalofucker Toolbox"
    echo "========================================================"
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
    echo "7. Khôi phục file hosts cũ"
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


download_filter() {
    local url=$1
    local name=$2
    local output_file="$TEMP_DIR/$name.txt"
    
    echo -e "${CYAN}Đang tải filter $name...${NC}"
    
    curl -s -f -o "$output_file" "$url"
    
    if [ $? -eq 0 ] && [ -s "$output_file" ]; then
        echo -e "${BRIGHT_BLUE}✓ Đã tải thành công filter $name${NC}"
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
        echo "     - Mở trình duyệt và thử truy cập: https://githubstatus.com kiểm tra xem có đang sập không"
        echo "     - Hoặc ping: ping -c 3 1.1.1.1"
        echo ""
        echo "  ► Bước 2: Kiểm tra curl có hoạt động không"
        echo "     - Mở Terminal và gõ: curl --version"
        echo "     - Nếu lỗi, cài đặt curl: brew install curl"
        echo ""
        echo "  ► Bước 4: Tắt tạm thời Firewall"
        echo "     - System Preferences → Security & Privacy → Firewall"
        echo "     - Hoặc thử: sudo pfctl -d"
        echo ""
        echo "  ► Bước 5: Liên hệ hỗ trợ"
        echo "     - Gửi mail đến: luxediro.madiheo@collector.org"
        echo "     - Tạo ticket trên Github: https://github.com/orgs/zalofucker/discussions"
        echo ""
        echo "========================================================"
        echo ""
        # Hỏi người dùng có muốn mở trang hỗ trợ không
        while true; do
            read -p "Bạn có muốn mở trang hỗ trợ trên Github? (Y/N): " choice
            case "$choice" in
                [Yy]* )
                    echo "Đang mở trang hỗ trợ..."
                    open "https://github.com/orgs/zalofucker/discussions"
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
        echo ""
        echo "📋 NGUYÊN NHÂN CÓ THỂ:"
        echo "  1. File bộ lọc chưa được tải về"
        echo "  2. Quá trình tải bị gián đoạn giữa chừng"
        echo "  3. Thư mục /tmp bị xóa hoặc thiếu quyền"
        echo ""
        echo "🔧 HƯỚNG DẪN KHẮC PHỤC:"
        echo ""
        echo "  ► Bước 1: Thử tải lại bộ lọc"
        echo "     - Quay lại menu chính và chọn lại chức năng"
        echo "     - Hoặc chọn 'Chặn tất cả' để tải lại toàn bộ"
        echo ""
        echo "  ► Bước 2: Kiểm tra thư mục tạm"
        echo "     - Chạy lệnh: ls -la /tmp/mac-zalofucker-toolbox/"
        echo "     - Xem có file $name.txt không"
        echo ""
        echo "  ► Bước 3: Khởi động lại script"
        echo "     - Thoát script và chạy lại với quyền sudo: sudo ./mac-zalofucker-toolbox.sh"
        echo ""
        echo "  ► Bước 4: Liên hệ hỗ trợ"
        echo "     - Gửi mail đến: luxediro.madiheo@collector.org"
        echo "     - Tạo ticket trên Github: https://github.com/orgs/zalofucker/discussions"
        echo ""
        echo "========================================================"
        while true; do
            read -p "Bạn có muốn mở trang hỗ trợ trên Github? (Y/N): " choice
            case "$choice" in
                [Yy]* )
                    echo "Đang mở trang hỗ trợ..."
                    open "https://github.com/orgs/zalofucker/discussions"
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
        
        # Flush DNS cache
        echo -e "${CYAN}Đang làm mới DNS cache...${NC}"
        sudo dscacheutil -flushcache
        sudo killall -HUP mDNSResponder
        echo -e "${BRIGHT_BLUE}✓ Đã làm mới DNS cache${NC}"
        return 0
    else
        echo ""
        echo "========================================================"
        echo "         LỖI: KHÔNG THỂ ÁP DỤNG BỘ LỌC VÀO HOSTS"
        echo "========================================================"
        echo ""
        echo "📋 NGUYÊN NHÂN CÓ THỂ:"
        echo "  1. Không có quyền sudo/root"
        echo "  2. File /etc/hosts bị khóa hoặc chỉ đọc"
        echo "  3. Dung lượng đĩa đầy (không còn chỗ trống)"
        echo "  4. File hosts đang được chương trình khác sử dụng"
        echo "  5. System Integrity Protection (SIP) đang bật"
        echo ""
        echo "🔧 HƯỚNG DẪN KHẮC PHỤC:"
        echo ""
        echo "  ► Bước 1: Kiểm tra quyền sudo"
        echo "     - Chạy script với sudo: sudo ./mac-zalofucker-toolbox.sh"
        echo "     - Nhập mật khẩu quản trị (sudo) khi được yêu cầu"
        echo ""
        echo "  ► Bước 2: Kiểm tra quyền file hosts"
        echo "     - Chạy lệnh: ls -l /etc/hosts"
        echo "     - Nếu readonly, chạy: sudo chflags nouchg /etc/hosts"
        echo ""
        echo "  ► Bước 3: Kiểm tra dung lượng đĩa"
        echo "     - Chạy lệnh: df -h"
        echo "     - Xóa file không cần thiết nếu đầy"
        echo ""
        echo "  ► Bước 4: Kiểm tra SIP (chỉ dành cho advanced user)"
        echo "     - Chạy lệnh: csrutil status"
        echo "     - Nếu đang ở trạng thái enabled, bạn có thể đọc qua tham khảo: https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection"
        echo ""
        echo "  ► Bước 6: Liên hệ hỗ trợ"
        echo "     - Gửi mail đến: luxediro.mahideo@collector.org"
        echo "     - Tạo ticket: https://github.com/orgs/zalofucker/discussions"
        echo ""
        echo "========================================================"
        echo ""
        while true; do
            read -p "Bạn có muốn mở trang hỗ trợ trên Github? (Y/N): " choice
            case "$choice" in
                [Yy]* )
                    echo "Đang mở trang hỗ trợ..."
                    open "https://github.com/orgs/zalofucker/discussions"
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
        return 1
    fi
    
    echo -e "${BRIGHT_BLUE}Kết quả: $success_count thành công, $fail_count thất bại${NC}"
    
    
    if [ -s "$combined_file" ]; then
        apply_filter "$combined_file" "TẤT CẢ"
        return $?
    else
        echo -e "${BLUE}✗ File kết hợp rỗng${NC}"
        return 1
    fi
}


restore_hosts() {
    if [ -f "$BACKUP_FILE" ]; then
        echo -e "${CYAN}Đang khôi phục file hosts...${NC}"
        sudo cp "$BACKUP_FILE" "$HOSTS_FILE"
        
        if [ $? -eq 0 ]; then
            echo -e "${BRIGHT_BLUE}✓ Đã khôi phục file hosts${NC}"
            
            # Flush DNS cache
            sudo dscacheutil -flushcache
            sudo killall -HUP mDNSResponder
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
            open "https://github.com/orgs/zalofucker/discussions"
        fi
        return 1
    fi
}

# Hàm kiểm tra trạng thái
check_status() {
    echo -e "${BRIGHT_BLUE}=== KIỂM TRA TRẠNG THÁI CHẶN ===${NC}"
    
    local domains=("zalo.me" "zalopay.vn" "zingmp3.vn" "labankey.com" "kiki.zalo.ai")
    
    for domain in "${domains[@]}"; do
        check_ping "$domain"
        echo ""
    done
}

# Hàm kiểm tra và yêu cầu quyền sudo
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
            echo -e "${CYAN}Vui lòng nhập mật khẩu quản trị:${NC}"
            echo ""
            
            # Tự động chạy lại script với sudo
            sudo "$0" "$@"
            exit $?
        else
            echo ""
            echo -e "${BLUE}✗ Đã hủy do thiếu quyền sudo để hoạt động.${NC}"
            echo ""
            echo "💡 TIP: Chạy script bằng lệnh:"
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
