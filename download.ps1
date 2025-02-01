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