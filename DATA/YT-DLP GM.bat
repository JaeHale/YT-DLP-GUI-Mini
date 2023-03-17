@echo off

:Start
  cls
  type "main.txt"
  echo:
  set /p Main=Choose an option: 
  if %Main%==1 goto Download
  if %Main%==2 goto Search
  exit

:Download
  cls
  type "download.txt"
  echo:
  for /f "usebackq tokens=2,*" %%a in (`REG QUERY "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v {374DE290-123F-4565-9164-39C4925E467B}`) do (set downloads=%%b)
  set /p YtLink=Paste Link from video sharing site: 
  set /p FileType=Choose a file type (mp3, m4a, mp4, webm, etc.) or push ENTER for default (Default extension: mp4) 
  set /p FileLocate=Set a destination for downloaded file or push ENTER for default location (Default location: Downloads) 
  set /p FileName=Set a name for the file or push ENTER for default (Default name: downloadedcontent.[extension]) 
  if [%FileLocate%]==[] (set FileLocate=%downloads%)
  if [%FileType%]==[] (set FileType="mp4")
  if [%FileName%]==[] (.\yt-dlp -o "downloadedcontent.%%(ext)s" -P "%FileLocate%" -f %FileType% %YtLink%) else (.\yt-dlp -o "%FileName%.%%(ext)s" -P "%FileLocate%" -f %FileType% %YtLink%)
  set /p Reset=Download another video? (Y or N) 
  if /i "%Reset%"=="y" goto Download
  goto Start

:Search
  cls
  type "search.txt"
  echo:
  set /p SearchTerm=Choose a term to search for on Youtube.com: 
  .\yt-dlp ytsearch5:%SearchTerm% --get-id --get-title
  set /p Reset2=Search for another term? (Y or N) 
  if /i "%Reset2%"=="y" goto Search
  goto Start
