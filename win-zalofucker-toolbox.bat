@echo off
chcp 65001 >nul
color 0B
title Zalofucker Toolbox version 0.0.5

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ================================================
    echo  CẢNH BÁO: Cần quyền Administrator!
    echo ================================================
    echo.
    set /p choice="Bạn có muốn cấp quyền Administrator không? (Y/N): "
    if /i "!choice!"=="Y" (
        echo Đang cấp quyền Admin...
        powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
        exit
    ) else (
        echo Chịu...
        pause >nul
        exit
    )
)


:MENU
cls
echo ========================================================
echo            Zalofucker Toolbox
echo ========================================================
echo Version 0.0.5
echo.
echo  [1] Chặn Zalo
echo  [2] Chặn ZaloPay
echo  [3] Chặn ZingMP3
echo  [4] Chặn Labankey
echo  [5] Chặn Kiki
echo  [6] Chặn TẤT CẢ
echo  [7] Gỡ chặn (Khôi phục hosts về mặc định)
echo  [8] Mở file host
echo  [9] Kiểm tra trạng thái chặn
echo  [0] Thoát
echo.
echo ========================================================
set /p choice="Nhập lựa chọn của bạn (0-9): "

if "%choice%"=="1" goto BLOCK_ZALO
if "%choice%"=="2" goto BLOCK_ZALOPAY
if "%choice%"=="3" goto BLOCK_ZINGMP3
if "%choice%"=="4" goto BLOCK_LABANKEY
if "%choice%"=="5" goto BLOCK_KIKI
if "%choice%"=="6" goto BLOCK_ALL
if "%choice%"=="7" goto UNBLOCK
if "%choice%"=="8" goto OPEN_HOSTS
if "%choice%"=="9" goto CHECK_PING
if "%choice%"=="0" goto EXIT
goto MENU

:BLOCK_ZALO
echo.
echo Đang tải danh sách chặn Zalo...
set "URL_ZALO=https://raw.githubusercontent.com/zalofucker/fuck-you-zalo/refs/heads/main/windows.txt"
set "TEMP_FILE=%TEMP%\block_zalo.txt"
curl -s -o "%TEMP_FILE%" "%URL_ZALO%"
if exist "%TEMP_FILE%" (
    call :APPLY_HOSTS "%TEMP_FILE%"
    call :CHECK_BLOCK "zalo.me" "Zalo"
) else (
    call :SHOW_ERROR_GUIDE
)
goto END_OPERATION

:BLOCK_ZALOPAY
echo.
echo Đang tải danh sách chặn ZaloPay...
set "URL_ZALOPAY=https://raw.githubusercontent.com/zalofucker/fuck-you-zalopay/refs/heads/main/windows.txt"
set "TEMP_FILE=%TEMP%\block_zalopay.txt"
curl -s -o "%TEMP_FILE%" "%URL_ZALOPAY%"
if exist "%TEMP_FILE%" (
    call :APPLY_HOSTS "%TEMP_FILE%"
    call :CHECK_BLOCK "zalopay.vn" "ZaloPay"
) else (
    call :SHOW_ERROR_GUIDE
)
goto END_OPERATION

:BLOCK_ZINGMP3
echo.
echo Đang tải danh sách chặn ZingMP3...
set "URL_ZINGMP3=https://raw.githubusercontent.com/zalofucker/fuck-you-zingmp3/refs/heads/main/windows.txt"
set "TEMP_FILE=%TEMP%\block_zingmp3.txt"
curl -s -o "%TEMP_FILE%" "%URL_ZINGMP3%"
if exist "%TEMP_FILE%" (
    call :APPLY_HOSTS "%TEMP_FILE%"
    call :CHECK_BLOCK "zingmp3.vn" "ZingMP3"
) else (
    call :SHOW_ERROR_GUIDE
)
goto END_OPERATION


:BLOCK_KIKI
echo.
echo Đang tải danh sách chặn Kiki...
set "URL_KIKI=https://raw.githubusercontent.com/zalofucker/fuck-you-kiki/refs/heads/main/windows.txt"
set "TEMP_FILE=%TEMP%\block_kiki.txt"
curl -s -o "%TEMP_FILE%" "%URL_KIKI%"
if exist "%TEMP_FILE%" (
    call :APPLY_HOSTS "%TEMP_FILE%"
    call :CHECK_BLOCK "kiki.zalo.ai" "Kiki"
) else (
    call :SHOW_ERROR_GUIDE
)
goto END_OPERATION


:BLOCK_LABANKEY
echo.
echo Đang tải danh sách chặn Labankey...
set "URL_LABANKEY=https://raw.githubusercontent.com/zalofucker/fuck-you-labankey/refs/heads/main/windows.txt"
set "TEMP_FILE=%TEMP%\block_labankey.txt"
curl -s -o "%TEMP_FILE%" "%URL_LABANKEY%"
if exist "%TEMP_FILE%" (
    call :APPLY_HOSTS "%TEMP_FILE%"
    call :CHECK_BLOCK "labankey.com" "Labankey"
) else (
    call :SHOW_ERROR_GUIDE
)
goto END_OPERATION

:BLOCK_ALL
echo.
echo ========================================================
echo  Đang tải TẤT CẢ danh sách chặn...
echo ========================================================
echo.

set "URL_ZALO=https://raw.githubusercontent.com/zalofucker/fuck-you-zalo/refs/heads/main/windows.txt"
set "URL_ZALOPAY=https://raw.githubusercontent.com/zalofucker/fuck-you-zalopay/refs/heads/main/windows.txt"
set "URL_ZINGMP3=https://raw.githubusercontent.com/zalofucker/fuck-you-zingmp3/refs/heads/main/windows.txt"
set "URL_KIKI=https://raw.githubusercontent.com/zalofucker/fuck-you-kiki/refs/heads/main/windows.txt"
set "URL_LABANKEY=https://raw.githubusercontent.com/zalofucker/fuck-you-labankey/refs/heads/main/windows.txt"

set "TEMP_ALL=%TEMP%\block_all.txt"
set "TEMP_ZALO=%TEMP%\temp_zalo.txt"
set "TEMP_ZALOPAY=%TEMP%\temp_zalopay.txt"
set "TEMP_ZINGMP3=%TEMP%\temp_zingmp3.txt"
set "TEMP_KIKI=%TEMP%\temp_kiki.txt"
set "TEMP_LABANKEY=%TEMP%\temp_labankey.txt"

if exist "%TEMP_ALL%" del "%TEMP_ALL%"
if exist "%TEMP_ZALO%" del "%TEMP_ZALO%"
if exist "%TEMP_ZALOPAY%" del "%TEMP_ZALOPAY%"
if exist "%TEMP_ZINGMP3%" del "%TEMP_ZINGMP3%"
if exist "%TEMP_KIKI%" del "%TEMP_KIKI%"
if exist "%TEMP_LABANKEY%" del "%TEMP_LABANKEY%"

set SUCCESS_COUNT=0
set FAIL_COUNT=0
set FAIL_LIST=

echo [1/5] Đang tải Zalo...
curl -s -o "%TEMP_ZALO%" "%URL_ZALO%"
if exist "%TEMP_ZALO%" (
    type "%TEMP_ZALO%" >> "%TEMP_ALL%"
    echo       [✓] Thành công
    set /a SUCCESS_COUNT+=1
) else (
    echo       [✗] Thất bại
    set /a FAIL_COUNT+=1
    set FAIL_LIST=!FAIL_LIST! Zalo,
)

echo [2/5] Đang tải ZaloPay...
curl -s -o "%TEMP_ZALOPAY%" "%URL_ZALOPAY%"
if exist "%TEMP_ZALOPAY%" (
    type "%TEMP_ZALOPAY%" >> "%TEMP_ALL%"
    echo       [✓] Thành công
    set /a SUCCESS_COUNT+=1
) else (
    echo       [✗] Thất bại
    set /a FAIL_COUNT+=1
    set FAIL_LIST=!FAIL_LIST! ZaloPay,
)

echo [3/5] Đang tải ZingMP3...
curl -s -o "%TEMP_ZINGMP3%" "%URL_ZINGMP3%"
if exist "%TEMP_ZINGMP3%" (
    type "%TEMP_ZINGMP3%" >> "%TEMP_ALL%"
    echo       [✓] Thành công
    set /a SUCCESS_COUNT+=1
) else (
    echo       [✗] Thất bại
    set /a FAIL_COUNT+=1
    set FAIL_LIST=!FAIL_LIST! ZingMP3,
)

echo [4/5] Đang tải Kiki...
curl -s -o "%TEMP_KIKI%" "%URL_KIKI%"
if exist "%TEMP_KIKI%" (
    type "%TEMP_KIKI%" >> "%TEMP_ALL%"
    echo       [✓] Thành công
    set /a SUCCESS_COUNT+=1
) else (
    echo       [✗] Thất bại
    set /a FAIL_COUNT+=1
    set FAIL_LIST=!FAIL_LIST! ZingMP3,
)

echo [5/5] Đang tải Labankey...
curl -s -o "%TEMP_LABANKEY%" "%URL_LABANKEY%"
if exist "%TEMP_LABANKEY%" (
    type "%TEMP_LABANKEY%" >> "%TEMP_ALL%"
    echo       [✓] Thành công
    set /a SUCCESS_COUNT+=1
) else (
    echo       [✗] Thất bại
    set /a FAIL_COUNT+=1
    set FAIL_LIST=!FAIL_LIST! Labankey,
)

echo.
echo ========================================================
echo  KẾT QUẢ TẢI FILE
echo ========================================================
echo  Thành công: %SUCCESS_COUNT%/5
echo  Thất bại: %FAIL_COUNT%/5

if %FAIL_COUNT% gtr 0 (
    echo  Các file lỗi:%FAIL_LIST:~0,-1%
)
echo ========================================================
echo.

:: Nếu có ít nhất 1 file thành công thì áp dụng
if %SUCCESS_COUNT% gtr 0 (
    if exist "%TEMP_ALL%" (
        call :APPLY_HOSTS "%TEMP_ALL%"
        echo.
        echo Kiểm tra chặn các trang web...
        call :CHECK_BLOCK "zalo.me" "Zalo"
        call :CHECK_BLOCK "zalopay.vn" "ZaloPay"
        call :CHECK_BLOCK "zingmp3.vn" "ZingMP3"
        call :CHECK_BLOCK "kiki.zalo.ai" "Kiki"
        call :CHECK_BLOCK "labankey.com" "Labankey"
    )
    
    :: Nếu có file bị lỗi, hiển thị cảnh báo
    if %FAIL_COUNT% gtr 0 (
        echo.
        echo CẢNH BÁO: Một số file không tải được!
        echo Các trang web tương ứng có thể CHƯA được chặn hoàn toàn.
        echo.
        call :SHOW_ERROR_GUIDE
    )
) else (
    echo LỖI: TẤT CẢ các file đều tải thất bại!
    echo.
    call :SHOW_ERROR_GUIDE
)


if exist "%TEMP_ZALO%" del "%TEMP_ZALO%"
if exist "%TEMP_ZALOPAY%" del "%TEMP_ZALOPAY%"
if exist "%TEMP_ZINGMP3%" del "%TEMP_ZINGMP3%"
if exist "%TEMP_KIKI%" del "%TEMP_KIKI%"
if exist "%TEMP_LABANKEY%" del "%TEMP_LABANKEY%"

goto END_OPERATION


if exist "%TEMP_ALL%" (
    call :APPLY_HOSTS "%TEMP_ALL%"
    echo.
    echo Kiểm tra chặn các trang web...
    call :CHECK_BLOCK "zalo.me" "Zalo"
    call :CHECK_BLOCK "zalopay.vn" "ZaloPay"
    call :CHECK_BLOCK "zingmp3.vn" "ZingMP3"
    call :CHECK_BLOCK "kiki.zalo.ai" "Kiki"
    call :CHECK_BLOCK "labankey.com" "Labankey"
) else (
    echo Không thể tải các file chặn!
)
goto END_OPERATION

:APPLY_HOSTS
set "HOSTS_FILE=%SystemRoot%\System32\drivers\etc\hosts"
set "BACKUP_FILE=%SystemRoot%\System32\drivers\etc\hosts.backup"

:: Backup hosts file nếu chưa có
if not exist "%BACKUP_FILE%" (
    echo Đang sao lưu file hosts gốc...
    copy "%HOSTS_FILE%" "%BACKUP_FILE%" >nul
)

:: Thêm nội dung vào hosts file
echo Đang áp dụng cấu hình chặn...
type "%~1" >> "%HOSTS_FILE%"
echo Hoàn tất!
ipconfig /flushdns >nul 2>&1
exit /b

:CHECK_BLOCK
echo.
echo Kiểm tra chặn %~2 (%~1)...
ping -n 1 -w 1000 %~1 >nul 2>&1
if %errorLevel% neq 0 (
    echo [✓] %~2 đã được chặn thành công!
) else (
    echo [✗] %~2 CHƯA được chặn hoàn toàn.
    echo.
    set /p opensite="Bạn có muốn mở trang web hỗ trợ không? (Y/N): "
    if /i "!opensite!"=="Y" (
        start https://github.com/orgs/zalofucker/discussions
    )
)
exit /b

:UNBLOCK
echo.
set "HOSTS_FILE=%SystemRoot%\System32\drivers\etc\hosts"
set "BACKUP_FILE=%SystemRoot%\System32\drivers\etc\hosts.backup"

if exist "%BACKUP_FILE%" (
    echo Đang khôi phục file hosts gốc...
    copy /y "%BACKUP_FILE%" "%HOSTS_FILE%" >nul
    echo Hoàn tất!
    ipconfig /flushdns >nul 2>&1
    echo Đã gỡ bỏ tất cả chặn!
) else (
    echo Không tìm thấy file backup!
)
goto END_OPERATION

:OPEN_HOSTS
echo.
set "HOSTS_FILE=%SystemRoot%\System32\drivers\etc\hosts"
echo Đang mở file hosts...
echo Đường dẫn: %HOSTS_FILE%
echo.

:: Kiểm tra file có tồn tại không
if exist "%HOSTS_FILE%" (
    :: Thử mở bằng notepad
    start notepad "%HOSTS_FILE%"
    echo [✓] Đã mở file hosts bằng Notepad!
    echo.
    echo LƯU Ý: Bạn cần quyền Administrator để chỉnh sửa file này.
) else (
    echo [✗] Không tìm thấy file hosts!
)
goto END_OPERATION

:SHOW_ERROR_GUIDE
echo.
echo ========================================================
echo             LỖI: KHÔNG THỂ TẢI FILE BỘ LỌC
echo ========================================================
echo.
echo 📋 NGUYÊN NHÂN CÓ THỂ:
echo   1. Không có kết nối Internet
echo   2. Máy chủ GitHub bị chặn hoặc bị ăn r
echo   3. URL nguồn bị thay đổi hoặc không còn tồn tại
echo   4. Firewall/Antivirus đang chặn tool
echo.
echo 🔧 HƯỚNG DẪN KHẮC PHỤC:
echo.
echo   ► Bước 1: Kiểm tra kết nối Internet
echo      - Mở trình duyệt và thử truy cập: https://example.com
echo      - Mở trình duyệt và thử truy cập: https://www.githubstatus.com/
echo.
echo   ► Bước 2: Kiểm tra curl có hoạt động không
echo      - Mở CMD và gõ: curl --version
echo      - Nếu lỗi, cài đặt curl hoặc cập nhật Windows
echo.
echo.
echo   ► Bước 4: Tắt tạm thời Firewall/Antivirus
echo      - Bạn có thể tham khảo: https://4get.ca/web?s=how%20to%20disable%20antivirut
echo.
echo   ► Bước 5: Liên hệ hỗ trợ
echo      - Gửi mail đến: luxediro.mahideo@collector.org
echo      - Tạo ticket trên Github: https://github.com/orgs/zalofucker/discussions
echo.
echo ========================================================
set /p openhelp="Bạn có muốn mở trang báo lỗi không không? (Y/N): "
if /i "%openhelp%"=="Y" (
    start https://github.com/zalofucker/issues-tracker/issues
    echo Đã mở trang hỗ trợ trong trình duyệt!
)
exit /b

:CHECK_PING
cls
echo ========================================================
echo           KIỂM TRA TRẠNG THÁI CHẶN
echo ========================================================
echo.
echo Đang kiểm tra trạng thái chặn các dịch vụ...
echo.

set "BLOCKED_COUNT=0"
set "UNBLOCKED_COUNT=0"
set "BLOCKED_LIST="
set "UNBLOCKED_LIST="

:: Kiểm tra Zalo
echo [1/5] Kiểm tra Zalo (zalo.me)...
ping -n 1 -w 1000 zalo.me >nul 2>&1
if %errorLevel% neq 0 (
    echo       [✓] Zalo đã được chặn
    set /a BLOCKED_COUNT+=1
    set "BLOCKED_LIST=!BLOCKED_LIST! Zalo (zalo.me),"
) else (
    echo       [✗] Zalo CHƯA được chặn
    set /a UNBLOCKED_COUNT+=1
    set "UNBLOCKED_LIST=!UNBLOCKED_LIST! Zalo (zalo.me),"
)

:: Kiểm tra ZaloPay
echo [2/5] Kiểm tra ZaloPay (zalopay.vn)...
ping -n 1 -w 1000 zalopay.vn >nul 2>&1
if %errorLevel% neq 0 (
    echo       [✓] ZaloPay đã được chặn
    set /a BLOCKED_COUNT+=1
    set "BLOCKED_LIST=!BLOCKED_LIST! ZaloPay (zalopay.vn),"
) else (
    echo       [✗] ZaloPay CHƯA được chặn
    set /a UNBLOCKED_COUNT+=1
    set "UNBLOCKED_LIST=!UNBLOCKED_LIST! ZaloPay (zalopay.vn),"
)

:: Kiểm tra ZingMP3
echo [3/5] Kiểm tra ZingMP3 (zingmp3.vn)...
ping -n 1 -w 1000 zingmp3.vn >nul 2>&1
if %errorLevel% neq 0 (
    echo       [✓] ZingMP3 đã được chặn
    set /a BLOCKED_COUNT+=1
    set "BLOCKED_LIST=!BLOCKED_LIST! ZingMP3 (zingmp3.vn),"
) else (
    echo       [✗] ZingMP3 CHƯA được chặn
    set /a UNBLOCKED_COUNT+=1
    set "UNBLOCKED_LIST=!UNBLOCKED_LIST! ZingMP3 (zingmp3.vn),"
)

:: Kiểm tra Kiki
echo [4/5] Kiểm tra Kiki (kiki.zalo.ai)...
ping -n 1 -w 1000 kiki.zalo.ai >nul 2>&1
if %errorLevel% neq 0 (
    echo       [✓] Kiki đã được chặn
    set /a BLOCKED_COUNT+=1
    set "BLOCKED_LIST=!BLOCKED_LIST! Kiki (kiki.zalo.ai),"
) else (
    echo       [✗] Kiki CHƯA được chặn
    set /a UNBLOCKED_COUNT+=1
    set "UNBLOCKED_LIST=!UNBLOCKED_LIST! Kiki (kiki.zalo.ai),"
)

:: Kiểm tra Labankey
echo [5/5] Kiểm tra Labankey (labankey.com)...
ping -n 1 -w 1000 labankey.com >nul 2>&1
if %errorLevel% neq 0 (
    echo       [✓] Labankey đã được chặn
    set /a BLOCKED_COUNT+=1
    set "BLOCKED_LIST=!BLOCKED_LIST! Labankey (labankey.com),"
) else (
    echo       [✗] Labankey CHƯA được chặn
    set /a UNBLOCKED_COUNT+=1
    set "UNBLOCKED_LIST=!UNBLOCKED_LIST! Labankey (labankey.com),"
)

echo.
echo ========================================================
echo              KẾT QUẢ KIỂM TRA
echo ========================================================
echo.
echo Đã chặn: %BLOCKED_COUNT%/5
if %BLOCKED_LIST% neq "" (
    echo   + %BLOCKED_LIST:~0,-1%
)
echo.
echo Chưa chặn: %UNBLOCKED_COUNT%/5
if %UNBLOCKED_LIST% neq "" (
    echo   - %UNBLOCKED_LIST:~0,-1%
)
echo.
goto END_OPERATION

:END_OPERATION
echo.
echo ========================================================
pause
goto MENU

:EXIT
echo.
echo Cảm ơn bạn đã sử dụng công cụ!
echo Fuck you Zalo
timeout /t 2 >nul

exit
