@echo off
title 啟動開發環境
echo 正在啟動 json-server...
start cmd /k "npx json-server db.json --port 3000"

REM 等待 2 秒讓 json-server 啟動
timeout /t 2 >nul

echo 正在啟動 npm run dev...
start cmd /k "npm run dev"

REM 等待 3 秒讓前端伺服器啟動
timeout /t 3 >nul

echo 正在開啟瀏覽器...
start http://localhost:5173

echo.
echo ✅ 所有服務已啟動！
echo 按 Ctrl+C 可手動關閉命令視窗。
pause
