@echo off
chcp 65001 >nul
title 🎬 YouTube 视频下载器 - yt-dlp 🚀

:: 设置窗口大小（宽 100，高 35）
MODE CON: COLS=100 LINES=35

:: 删除旧的 download.ps1 文件（如果存在）
if exist "%~dp0download.ps1" (
    del "%~dp0download.ps1"
)

:: 显示载入提示并下载最新的 PowerShell 脚本
echo 载入中...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/panda44312/yt-dlp/main/download.ps1', '%~dp0download.ps1')"

:: 运行 PowerShell 脚本
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0download.ps1"

:: 删除旧的 download.ps1 文件（如果存在）
if exist "%~dp0download.ps1" (
    del "%~dp0download.ps1"
)

:: 执行完毕后退出
exit
