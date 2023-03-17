@echo off
  for /f "usebackq tokens=2,*" %%a in (`REG QUERY "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v {374DE290-123F-4565-9164-39C4925E467B}`) do set downloads=%%b
  for /f "tokens=2 delims==" %%c in ('findstr "DefaultType=" settings.txt') do set "DefaultType=%%c"
  for /f "tokens=2 delims==" %%d in ('findstr "DefaultLocation=" settings.txt') do set "DefaultLocation=%%d"
  for /f "tokens=2 delims==" %%e in ('findstr "DefaultName=" settings.txt') do set "DefaultName=%%e"

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
  set /p YtLink=Paste link or ID from video sharing site: 
  set /p FileType=Choose a file type (mp3, m4a, mp4, webm, etc.) or push ENTER for default [Default extension: %DefaultType%] 
  if [%FileType%]==[] set FileType=%DefaultType%
  if %DefaultLocation%==%%downloads%% set "DefaultLocation=Downloads"
  set /p FileLocate=Set a destination for downloaded file or push ENTER for default location [Default location: %DefaultLocation%] 
  if %DefaultLocation%==Downloads set "DefaultLocation=%%downloads%%"
  if [%FileLocate%]==[] set FileLocate=%DefaultLocation%
  set /p FileName=Set a name for the file or push ENTER for default [Default name: %DefaultName%.%FileType%] 
  if [%FileName%]==[] (.\yt-dlp -o "%DefaultName%.%%(ext)s" -P "%FileLocate%" -f %FileType% %YtLink%) else (.\yt-dlp -o "%FileName%.%%(ext)s" -P "%FileLocate%" -f %FileType% %YtLink%)
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