# 设置 UTF-8 编码
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$host.UI.RawUI.WindowTitle = "🎬 YouTube 视频下载器 - yt-dlp 🚀"

# 初始化变量
$ffmpegExePath = ".\ffmpeg.exe"
$ytdlpExePath = ".\yt-dlp.exe"

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

# 主菜单
function Show-MainMenu {

    Clear-Host
    Write-Host "🎬 YouTube 视频下载器 - yt-dlp 🚀" -ForegroundColor Cyan

    Write-Host "`n📑 最近更新 2025/5/1 - v2.0" -ForegroundColor Cyan
    Write-Host "更新了下载频道功能`n更新了更多格式选单`n更新了 ffmpeg 工具箱" -ForegroundColor Cyan

    $poetry = @(
        "夜幕低垂染幽林，竹影摇风舞月轮。",
        "斑纹隐现生奇趣，心随清梦赴天心。",
        "林间晓露凝珠光，风吹竹影动诗章。",
        "悠然步入深竹径，月明风清伴我行。",
        "千里江水悠悠行，竹影随风舞轻盈。",
        "素影婆娑月影斜，心随思绪寄天涯。",
        "烟雾缭绕竹林间，影动影静心自闲。",
        "一枝翠竹竖苍穹，斑斓光影舞东风。",
        "白云悠悠锁青山，竹林深处月光寒。",
        "古道深林竹影斜，风吹歌声入梦花。",
        "月光如水洒林深，竹影轻摇映梦心。",
        "夜色微凉竹影长，心随梦远望天涯。",
        "幽林静谧月微照，心随竹影入梦遥。",
        "静夜悠悠风送声，竹影婆娑心似清。",
        "幽径深深竹影低，心随梦回踏青溪。",
        "翠竹如影斜阳下，心随风动寄天涯。",
        "风吹竹林千层影，月照苍穹万里情。",
        "竹影如诗如画，心随梦舞天涯。",
        "竹林月色轻盈舞，心随风随梦远走。",
        "白云翻滚影幽深，竹影伴月思悠悠。",
        "风起竹林深处行，月光洒下梦长情。",
        "草木幽深竹影浓，风起云涌梦未终。",
        "梦回竹林星空闪，心随风舞入梦眠。",
        "竹影随风轻摇曳，心随月光入梦迷。",
        "飞鸟归巢夜幕临，竹影深处心悠然。",
        "竹影斜阳心随风，月光如水洒林中。",
        "晨曦微露竹影新，风起云涌梦亦深。",
        "月光穿林照青竹，心随风舞逐星宿。",
        "竹林悠悠心渐远，月照千山不言愁。",
        "风吹竹林影婆娑，心随梦飞天边遥。",
        "独行竹间心自静，月光洒满夜未央。",
        "竹影婆娑月影冷，心随风舞入梦深。",
        "夜色渐浓风吹起，竹林幽静心飞远。",
        "风拂竹影随心动，月光如水伴我行。",
        "梦回竹林入清晨，心随风起梦中行。",
        "竹影低垂心悠然，月照青山心自安。",
        "斑纹舞动月影长，心随风起梦无疆。",
        "一帘幽梦竹影斜，心随月光入梦行。",
        "斑斓竹影月光凉，心随清风梦渐长。",
        "竹林深处月影冷，风起云涌梦随行。",
        "夜深竹影随风动，月光如水入梦浓。",
        "竹林幽静风轻吹，月光洒满夜未央。",
        "月光如水心随风，竹影悠悠伴我行。",
        "竹影摇曳月光寒，心随梦起飞天涯。",
        "风吹竹林千层影，月光洒下梦悠长。",
        "竹影随风如梦行，心随风飞天边遥。",
        "月影斜照竹影长，心随思绪梦徜徉。",
        "竹影斜阳心随风，月光如水洒山中。",
        "梦中竹林心自安，月光洒下静无言。",
        "风吹竹林心随动，月影轻摇伴我行。",
        "竹影婆娑心自静，风起云涌梦随风。",
        "竹林幽深风轻起，月光如水梦渐远。",
        "幽林寂静竹影深，月光洒下梦不寻。",
        "风动竹影心随梦，月光如水梦悠悠。",
        "竹影斜阳风吹起，心随梦远行天际。",
        "月光洒下竹影长，心随梦飞天涯远。",
        "风吹竹影心随行，月光如水照青山。",
        "夜色降临风起竹，心随梦远行天边。",
        "竹影轻摇心悠然，月光如水洒山川。",
        "风吹竹影随心动，月光如水照山川。",
        "风轻竹影心悠远，月光如水洒千山。",
        "竹影随风心如水，月光洒下梦悠悠。",
        "竹林深处风轻起，月光洒下心自静。",
        "夜幕降临风轻拂，竹影婆娑心自安。",
        "竹影随风心如水，月光洒下梦悠悠。",
        "风吹竹影心悠远，月光洒下梦未央。",
        "风轻竹影心随梦，月光如水洒千山。",
        "月光如水洒林中，竹影轻摇心悠远。",
        "竹影随风轻摇曳，心随梦飞天涯远。",
        "风起竹林影婆娑，月光如水心渐远。",
        "竹影斜阳风吹起，心随梦飞入天边。",
        "风起竹林心随动，月光如水照山川。",
        "竹影轻摇心悠远，月光洒下梦长情。",
        "竹林寂静风轻吹，心随梦远行天涯。",
        "风起竹影心随行，月光如水梦渐长。",
        "竹影随风轻摇曳，月光洒下心自安。",
        "月光洒下竹影斜，心随风动梦飞远。",
        "竹影轻摇心自静，风起云涌梦无边。",
        "月影斜照竹影长，心随清风梦悠悠。",
        "竹影婆娑月光凉，心随风舞入梦深。",
        "风吹竹影月光斜，心随梦远行天涯。",
        "竹影轻摇月光冷，心随风起梦长远。",
        "月光如水洒竹间，心随风舞梦天涯。",
        "风吹竹影如画行，月光如水伴我行。",
        "竹影婆娑心随风，月光如水洒山川。",
        "风轻竹影随心动，月光洒下梦未央。",
        "竹影随风如梦行，月光洒下心自安。",
        "风吹竹影心悠远，月光洒下梦无疆。",
        "竹影斜阳心随风，月光如水照山川。",
        "夜幕降临竹影浓，风轻吹起梦悠悠。",
        "竹影随风月如水，心随梦远飞天涯。",
        "风吹竹影如梦行，月光洒下心自安。",
        "竹影轻摇月影长，心随风起梦未央。",
        "月光如水照竹间，心随风舞梦悠悠。",
        "竹影深处月光冷，心随梦远飞天涯。",
        "竹影随风轻摇曳，月光如水梦悠悠。"
    )

    # 随机选择并输出诗词
    $randomPoem = $poetry | Get-Random
    Write-Host "`n$randomPoem"

    Write-Host "`n🏠 主菜单" -ForegroundColor Cyan
    Write-Host "1. 📽 下载单个视频"
    Write-Host "2. 📽 下载多个视频"
    Write-Host "3. 📑 下载播放列表"
    Write-Host "4. 📚 下载频道内容"
    Write-Host "5. 🔧 ffmpeg 工具箱"
    Write-Host "6. ❌ 退出"
    
    $choice = Read-Host "👉 请选择选项 (1-6)"
    
    switch ($choice) {
        "1" { Download-Single }
        "2" { Download-Multiple }
        "3" { Download-Playlist }
        "4" { Download-Channel }
        "5" { Show-ToolboxMenu }
        "6" { exit }
        default { Show-MainMenu }
    }
}

# 格式选择菜单
function Show-FormatMenu {
    Write-Host "`n🎬 请选择下载格式：" -ForegroundColor Cyan
    Write-Host "1.  🚀 最高画质 + 无损音频"
    Write-Host "2.  🎥 8K (4320p) MP4"
    Write-Host "3.  🎥 4K (2160p) MP4"
    Write-Host "4.  🎥 2K (1440p) MP4"
    Write-Host "5.  🎥 1080p MP4"
    Write-Host "6.  🎥 720p MP4"
    Write-Host "7.  🎥 480p MP4"
    Write-Host "8.  🎥 360p MP4"
    Write-Host "9.  🎥 240p MP4"
    Write-Host "10. 🎥 144p MP4"
    Write-Host "11. 🎞️ 8K (4320p) WebM"
    Write-Host "12. 🎞️ 4K (2160p) WebM"
    Write-Host "13. 🎞️ 1080p WebM"
    Write-Host "14. 🎞️ 720p WebM"
    Write-Host "15. 🎵 仅音频 (最佳质量 MP3)"
    Write-Host "16. 🎵 仅音频 (320kbps MP3)"
    Write-Host "17. 🎵 仅音频 (128kbps MP3)"
    Write-Host "18. 🎵 仅音频 (64kbps MP3)"
    Write-Host "19. 🎶 仅音频 (AAC)"

    $choice = Read-Host "👉 请输入你想要的格式"

    switch ($choice) {
        "1" { return "bestvideo[height<=4320][ext=mp4]+bestaudio[ext=m4a]/best[height<=4320][ext=mp4]" } 
        "2" { return "bestvideo[height<=4320][ext=mp4]+bestaudio[ext=m4a]/best[height<=4320][ext=mp4]" }
        "3" { return "bestvideo[height<=2160][ext=mp4]+bestaudio[ext=m4a]/best[height<=2160][ext=mp4]" }
        "4" { return "bestvideo[height<=1440][ext=mp4]+bestaudio[ext=m4a]/best[height<=1440][ext=mp4]" }
        "5" { return "bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[height<=1080][ext=mp4]" }
        "6" { return "bestvideo[height<=720][ext=mp4]+bestaudio[ext=m4a]/best[height<=720][ext=mp4]" }
        "7" { return "bestvideo[height<=480][ext=mp4]+bestaudio[ext=m4a]/best[height<=480][ext=mp4]" }
        "8" { return "bestvideo[height<=360][ext=mp4]+bestaudio[ext=m4a]/best[height<=360][ext=mp4]" }
        "9" { return "bestvideo[height<=240][ext=mp4]+bestaudio[ext=m4a]/best[height<=240][ext=mp4]" }
        "10" { return "bestvideo[height<=144][ext=mp4]+bestaudio[ext=m4a]/best[height<=144][ext=mp4]" }
        "11" { return "bestvideo[height<=4320][ext=webm]+bestaudio[ext=webm]/best[height<=4320][ext=webm]" }
        "12" { return "bestvideo[height<=2160][ext=webm]+bestaudio[ext=webm]/best[height<=2160][ext=webm]" }
        "13" { return "bestvideo[height<=1080][ext=webm]+bestaudio[ext=webm]/best[height<=1080][ext=webm]" }
        "14" { return "bestvideo[height<=720][ext=webm]+bestaudio[ext=webm]/best[height<=720][ext=webm]" }
        "15" { return "bestaudio/best --audio-format mp3" }  # 仅音频 (最佳质量 MP3)
        "16" { return "bestaudio[abr>=320]/bestaudio --audio-format mp3" }  # 仅音频 (320kbps MP3)
        "17" { return "bestaudio[abr>=128]/bestaudio --audio-format mp3" }  # 仅音频 (128kbps MP3)
        "18" { return "bestaudio[abr<=64]/bestaudio --audio-format mp3" }   # 仅音频 (64kbps MP3)
        "19" { return "bestaudio --audio-format aac" }  # 仅音频 (AAC)
        default { 
            Write-Host "⚠️  请输入正确的编号！" -ForegroundColor Red
            Show-FormatMenu 
        }
    }
}

# 工具箱功能
function Show-ToolboxMenu {
    Write-Host "`n🔧 ffmpeg 工具箱" -ForegroundColor Cyan
    Write-Host "1. 使用 ffmpeg 转换视频格式"
    Write-Host "2. 使用 ffmpeg 裁剪视频"
    Write-Host "3. 使用 ffmpeg 提取音频"
    Write-Host "4. 返回主菜单"
    
    $choice = Read-Host "👉 请选择选项 (1-4)"
    
    switch ($choice) {
        "1" { Convert-VideoFormat }
        "2" { Trim-Video }
        "3" { Extract-Audio }
        "4" { Show-MainMenu }
        default { Show-ToolboxMenu }
    }
}

# 转换视频格式
function Convert-VideoFormat {
    Write-Host "`n📥 请输入视频文件路径：" -ForegroundColor Cyan
    $inputFile = Read-Host "🔗 输入文件路径"
    
    Write-Host "`n🎬 请输入目标格式 (例如: mp4, avi, mkv)：" -ForegroundColor Cyan
    $outputFormat = Read-Host "目标格式"
    
    Write-Host "`n📁 请输入输出文件的存储路径：" -ForegroundColor Cyan
    $outputDir = Read-Host "输出路径"
    
    if ([string]::IsNullOrWhiteSpace($outputDir)) {
        $outputDir = "."
    }

    $outputFile = "$outputDir\$( [System.IO.Path]::GetFileNameWithoutExtension($inputFile) ).$outputFormat"

    try {
        Write-Host "`n⏳ 正在转换视频格式..." -ForegroundColor Yellow
        Start-Process -NoNewWindow -Wait -FilePath $ffmpegExePath -ArgumentList @(
            "-i", $inputFile,
            "$outputFile"
        )
    } catch {
        Handle-Error "格式转换失败: $_"
    }
    
    Write-Host "`n✅ 视频格式转换完成！按任意键返回工具箱菜单..." -ForegroundColor Green
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    Show-ToolboxMenu
}

# 裁剪视频
function Trim-Video {
    Write-Host "`n📥 请输入视频文件路径：" -ForegroundColor Cyan
    $inputFile = Read-Host "🔗 输入文件路径"
    
    Write-Host "`n🎬 请输入裁剪起始时间 (格式: HH:MM:SS)：" -ForegroundColor Cyan
    $startTime = Read-Host "起始时间"
    
    Write-Host "`n🎬 请输入裁剪持续时间 (格式: HH:MM:SS)：" -ForegroundColor Cyan
    $duration = Read-Host "持续时间"
    
    Write-Host "`n📁 请输入输出文件的存储路径：" -ForegroundColor Cyan
    $outputDir = Read-Host "输出路径"
    
    if ([string]::IsNullOrWhiteSpace($outputDir)) {
        $outputDir = "."
    }

    $outputFile = "$outputDir\$( [System.IO.Path]::GetFileNameWithoutExtension($inputFile) )_trimmed.mp4"

    try {
        Write-Host "`n⏳ 正在裁剪视频..." -ForegroundColor Yellow
        Start-Process -NoNewWindow -Wait -FilePath $ffmpegExePath -ArgumentList @(
            "-i", $inputFile,
            "-ss", $startTime,
            "-t", $duration,
            "$outputFile"
        )
    } catch {
        Handle-Error "视频裁剪失败: $_"
    }
    
    Write-Host "`n✅ 视频裁剪完成！按任意键返回工具箱菜单..." -ForegroundColor Green
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    Show-ToolboxMenu
}

# 提取音频
function Extract-Audio {
    Write-Host "`n📥 请输入视频文件路径：" -ForegroundColor Cyan
    $inputFile = Read-Host "🔗 输入文件路径"
    
    Write-Host "`n🎧 请选择提取的音频格式 (例如: mp3, wav)：" -ForegroundColor Cyan
    $audioFormat = Read-Host "音频格式"
    
    Write-Host "`n📁 请输入输出文件的存储路径：" -ForegroundColor Cyan
    $outputDir = Read-Host "输出路径"
    
    if ([string]::IsNullOrWhiteSpace($outputDir)) {
        $outputDir = "."
    }

    $outputFile = "$outputDir\$( [System.IO.Path]::GetFileNameWithoutExtension($inputFile) ).$audioFormat"

    try {
        Write-Host "`n⏳ 正在提取音频..." -ForegroundColor Yellow
        Start-Process -NoNewWindow -Wait -FilePath $ffmpegExePath -ArgumentList @(
            "-i", $inputFile,
            "-vn",  # 不包含视频
            "-acodec", "libmp3lame",
            "$outputFile"
        )
    } catch {
        Handle-Error "音频提取失败: $_"
    }
    
    Write-Host "`n✅ 音频提取完成！按任意键返回工具箱菜单..." -ForegroundColor Green
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    Show-ToolboxMenu
}


# 单个视频下载
function Download-Single {
    Write-Host "`n📥 请输入视频链接：" -ForegroundColor Cyan
    $url = Read-Host "🔗 URL"
    
    Write-Host "`n📁 请输入下载文件的存储路径（留空则使用当前目录）：" -ForegroundColor Cyan
    $outputDir = Read-Host "📂 输出目录"
    if ([string]::IsNullOrWhiteSpace($outputDir)) {
        $outputDir = "."
    }
    
    $format = Show-FormatMenu
    Start-Download @($url) $outputDir $format
    
    Write-Host "`n✅ 下载完成！按任意键返回主菜单..." -ForegroundColor Green
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

    Show-MainMenu
}

# 多个视频下载
function Download-Multiple {
    $urls = @()
    Write-Host "`n📥 请输入视频链接（每行一个，输入空行完成）：" -ForegroundColor Cyan
    while ($true) {
        $url = Read-Host "🔗 URL"
        if ([string]::IsNullOrWhiteSpace($url)) { break }
        $urls += $url
    }
    
    Write-Host "`n📁 请输入下载文件的存储路径（留空则使用当前目录）：" -ForegroundColor Cyan
    $outputDir = Read-Host "📂 输出目录"
    if ([string]::IsNullOrWhiteSpace($outputDir)) {
        $outputDir = "."
    }
    
    $format = Show-FormatMenu
    Start-Download $urls $outputDir $format
    
    Write-Host "`n✅ 所有下载完成！按任意键返回主菜单..." -ForegroundColor Green
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

    Show-MainMenu
}

# 播放列表下载
function Download-Playlist {
    Write-Host "`n📥 请输入播放列表链接：" -ForegroundColor Cyan
    $url = Read-Host "🔗 URL"
    
    Write-Host "`n📁 请输入下载文件的存储路径（留空则使用当前目录）：" -ForegroundColor Cyan
    $outputDir = Read-Host "📂 输出目录"
    if ([string]::IsNullOrWhiteSpace($outputDir)) {
        $outputDir = "."
    }
    
    $format = Show-FormatMenu
    
    try {
        Write-Host "`n⏳ 正在下载播放列表..." -ForegroundColor Yellow
        Start-Process -NoNewWindow -Wait -FilePath $ytdlpExePath -ArgumentList @(
            "-f", $format,
            "--ffmpeg-location", $ffmpegExePath,
            "-o", "`"$outputDir\%(playlist_title)s\%(title)s.%(ext)s`"",
            "--yes-playlist",
            $url
        )
    } catch {
        Handle-Error "播放列表下载失败: $_"
    }
    
    Write-Host "`n✅ 播放列表下载完成！按任意键返回主菜单..." -ForegroundColor Green
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

    Show-MainMenu
}

# 频道下载
function Download-Channel {
    Write-Host "`n📥 请输入频道URL：" -ForegroundColor Cyan
    $channelUrl = Read-Host "🔗 频道 URL"

    Write-Host "`n📁 请输入下载文件的存储路径（留空则使用当前目录）：" -ForegroundColor Cyan
    $outputDir = Read-Host "📂 输出目录"
    if ([string]::IsNullOrWhiteSpace($outputDir)) {
        $outputDir = "."
    }

    Write-Host "`n🎬 请选择下载模式：" -ForegroundColor Cyan
    Write-Host "1. 下载前 N 个视频"
    Write-Host "2. 下载指定日期后的视频"
    Write-Host "3. 返回主菜单"
    
    $choice = Read-Host "👉 请选择选项 (1-3)"
    
    switch ($choice) {
        "1" {
            $numVideos = Read-Host "📥 请输入要下载的视频数量"
            $filter = "--max-downloads $numVideos"
        }
        "2" {
            $date = Read-Host "📅 请输入日期 (格式: YYYYMMDD)"
            $filter = "--dateafter $date"
        }
        "3" {
            Show-MainMenu
            return
        }
        default {
            Write-Host "❌ 无效选择，返回主菜单..." -ForegroundColor Red
            Show-MainMenu
            return
        }
    }

    $format = Show-FormatMenu
    
    try {
        Write-Host "`n⏳ 正在下载频道内容..." -ForegroundColor Yellow
        Start-Process -NoNewWindow -Wait -FilePath $ytdlpExePath -ArgumentList @(
            "-f", $format,
            "--ffmpeg-location", $ffmpegExePath,
            "-o", "`"$outputDir\%(uploader)s\%(title)s.%(ext)s`"",
            $filter,
            $channelUrl
        )
    } catch {
        Handle-Error "频道下载失败: $_"
    }
    
    Write-Host "`n✅ 频道视频下载完成！按任意键返回主菜单..." -ForegroundColor Green
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    Show-MainMenu
}

# 下载文件的函数
function Download-File($url, $outputPath) {
    try {
        Write-Host "正在下载 $url ..."
        (New-Object System.Net.WebClient).DownloadFile($url, $outputPath)
        Write-Host "$outputPath 下载完成！"
    } catch {
        Write-Host "下载 $url 失败: $_"
        exit 1
    }
}

Clear-Host

# 检查 yt-dlp.exe
if (-not (Test-Path $ytdlpExePath)) {
    Write-Host "`n未找到 yt-dlp.exe，正在下载..."
    Download-File "https://github.com/panda44312/yt-dlp/raw/main/yt-dlp.exe" $ytdlpExePath
}

# 检查 ffmpeg.exe
if (-not (Test-Path $ffmpegExePath)) {
    Write-Host "`n未找到 ffmpeg.exe，正在下载..."
    Download-File "https://github.com/panda44312/yt-dlp/raw/main/ffmpeg.exe" $ffmpegExePath
}

# 启动主菜单
Show-MainMenu
