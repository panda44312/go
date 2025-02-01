# 设置 UTF-8 编码
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$host.UI.RawUI.WindowTitle = "🎬 YouTube 视频下载器 - yt-dlp 🚀"

# 初始化变量
$ffmpegExePath = ".\ffmpeg.exe"
$ytdlpExePath = ".\yt-dlp.exe"
$WorkerURL = "https://yt-dl-data.panda443212.workers.dev"

# 错误处理函数
function Handle-Error {
    param($ErrorMessage)
    Write-Host "`n❌ 错误: $ErrorMessage" -ForegroundColor Red
    Write-Host "按任意键返回主菜单..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    Show-MainMenu
}

# 显示支持的网站
function Show-SupportedSites {
    Write-Host "`n📋 支持的网站列表：" -ForegroundColor Cyan
    Start-Process -NoNewWindow -Wait -FilePath $ytdlpExePath -ArgumentList "--list-extractors"
    Write-Host "`n按任意键返回主菜单..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    Show-MainMenu
}

# 下载函数
function Start-Download {
    param($Urls, $OutputDir, $Format)
    
    foreach ($url in $Urls) {
        try {
            Write-Host "`n⏳ 正在下载: $url" -ForegroundColor Yellow
            if ($Format -like "*audio*") {
                Start-Process -NoNewWindow -Wait -FilePath $ytdlpExePath -ArgumentList @(
                    "-f", $Format,
                    "--ffmpeg-location", $ffmpegExePath,
                    "-o", "`"$OutputDir\%(title)s.%(ext)s`"",
                    "--extract-audio",
                    "--audio-format", "mp3",
                    $url
                )
            } else {
                Start-Process -NoNewWindow -Wait -FilePath $ytdlpExePath -ArgumentList @(
                    "-f", $Format,
                    "--ffmpeg-location", $ffmpegExePath,
                    "-o", "`"$OutputDir\%(title)s.%(ext)s`"",
                    $url
                )
            }
        } catch {
            Handle-Error "下载失败: $_"
        }
    }
}

# 新增：下载频道内容
function Download-Channel {
    Write-Host "`n📥 请输入频道URL：" -ForegroundColor Cyan
    $channelUrl = Read-Host "🔗 频道URL"
    
    Write-Host "`n📁 请输入下载文件的存储路径（留空则使用当前目录）：" -ForegroundColor Cyan
    $outputDir = Read-Host "📂 输出目录"
    if ([string]::IsNullOrWhiteSpace($outputDir)) {
        $outputDir = "."
    }
    
    Write-Host "`n📅 请选择下载范围：" -ForegroundColor Cyan
    Write-Host "1. 所有视频"
    Write-Host "2. 最新的N个视频"
    Write-Host "3. 指定日期之后的视频"
    $rangeChoice = Read-Host "👉 请选择 (1-3)"
    
    $dateFilter = ""
    switch ($rangeChoice) {
        "2" {
            $count = Read-Host "请输入要下载的视频数量"
            $dateFilter = "--max-downloads $count"
        }
        "3" {
            $date = Read-Host "请输入起始日期 (格式: YYYYMMDD)"
            $dateFilter = "--dateafter $date"
        }
    }
    
    $format = Show-FormatMenu
    
    try {
        Write-Host "`n⏳ 正在下载频道内容..." -ForegroundColor Yellow
        Start-Process -NoNewWindow -Wait -FilePath $ytdlpExePath -ArgumentList @(
            "-f", $format,
            "--ffmpeg-location", $ffmpegExePath,
            "-o", "`"$outputDir\%(uploader)s\%(title)s.%(ext)s`"",
            $dateFilter,
            "--yes-playlist",
            $channelUrl
        )
    } catch {
        Handle-Error "频道下载失败: $_"
    }
    
    Write-Host "`n✅ 频道内容下载完成！按任意键返回主菜单..." -ForegroundColor Green
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    Show-MainMenu
}

# 新增：格式转换工具
function Convert-MediaFormat {
    Write-Host "`n🛠️ 格式转换工具" -ForegroundColor Cyan
    Write-Host "1. 视频转换"
    Write-Host "2. 音频转换"
    $choice = Read-Host "👉 请选择 (1-2)"
    
    Write-Host "`n📁 请输入源文件路径："
    $inputFile = Read-Host "📂 输入文件"
    
    Write-Host "`n📁 请输入输出路径（留空则使用当前目录）："
    $outputDir = Read-Host "📂 输出目录"
    if ([string]::IsNullOrWhiteSpace($outputDir)) {
        $outputDir = "."
    }
    
    switch ($choice) {
        "1" {
            Write-Host "`n选择输出格式："
            Write-Host "1. MP4"
            Write-Host "2. MKV"
            Write-Host "3. AVI"
            Write-Host "4. MOV"
            $format = Read-Host "👉 请选择 (1-4)"
            
            $outputFormat = switch ($format) {
                "1" { "mp4" }
                "2" { "mkv" }
                "3" { "avi" }
                "4" { "mov" }
                default { "mp4" }
            }
        }
        "2" {
            Write-Host "`n选择输出格式："
            Write-Host "1. MP3"
            Write-Host "2. WAV"
            Write-Host "3. AAC"
            Write-Host "4. FLAC"
            $format = Read-Host "👉 请选择 (1-4)"
            
            $outputFormat = switch ($format) {
                "1" { "mp3" }
                "2" { "wav" }
                "3" { "aac" }
                "4" { "flac" }
                default { "mp3" }
            }
        }
    }
    
    $outputFile = Join-Path $outputDir "converted.$outputFormat"
    
    try {
        Write-Host "`n⏳ 正在转换..." -ForegroundColor Yellow
        if ($choice -eq "2") {
            Start-Process -NoNewWindow -Wait -FilePath $ffmpegExePath -ArgumentList @(
                "-i", "`"$inputFile`"",
                "-vn",
                "`"$outputFile`""
            )
        } else {
            Start-Process -NoNewWindow -Wait -FilePath $ffmpegExePath -ArgumentList @(
                "-i", "`"$inputFile`"",
                "`"$outputFile`""
            )
        }
        Write-Host "`n✅ 转换完成！输出文件：$outputFile" -ForegroundColor Green
    } catch {
        Handle-Error "转换失败: $_"
    }
    
    Write-Host "`n按任意键返回主菜单..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    Show-MainMenu
}

# 更新主菜单
function Show-MainMenu {
    Clear-Host
    Write-Host "🎬 YouTube 视频下载器 - yt-dlp 🚀" -ForegroundColor Cyan
    
    # 保留原有的随机诗词功能...
    $poetry = @( # 原有的诗词数组... )
    $randomPoem = $poetry | Get-Random
    Write-Host $randomPoem
    
    Write-Host "`n🏠 主菜单" -ForegroundColor Cyan
    Write-Host "1. 下载单个视频"
    Write-Host "2. 下载多个视频"
    Write-Host "3. 下载播放列表"
    Write-Host "4. 下载频道内容"
    Write-Host "5. 格式转换工具"
    Write-Host "6. 查看支持的网站"
    Write-Host "7. 退出"
    
    $choice = Read-Host "`n👉 请选择选项 (1-7)"
    
    switch ($choice) {
        "1" { Download-Single }
        "2" { Download-Multiple }
        "3" { Download-Playlist }
        "4" { Download-Channel }
        "5" { Convert-MediaFormat }
        "6" { Show-SupportedSites }
        "7" { exit }
        default { Show-MainMenu }
    }
}

# 主程序保持不变...
Clear-Host

# 检查依赖文件
if (-not (Test-Path $ytdlpExePath)) {
    Write-Host "`n未找到 yt-dlp.exe，正在下载..."
    Download-File "https://github.com/panda44312/yt-dlp/raw/main/yt-dlp.exe" $ytdlpExePath
}

if (-not (Test-Path $ffmpegExePath)) {
    Write-Host "`n未找到 ffmpeg.exe，正在下载..."
    Download-File "https://github.com/panda44312/yt-dlp/raw/main/ffmpeg.exe" $ffmpegExePath
}

# 启动主菜单
Show-MainMenu