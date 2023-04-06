@echo off
  for /f "usebackq tokens=2,*" %%a in (`REG QUERY "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v {374DE290-123F-4565-9164-39C4925E467B}`) do set downloads=%%b
  for /f "tokens=2 delims==" %%c in ('findstr "DefaultType=" defaults.dat') do set "DefaultType=%%c"
  set TempTrim=%DefaultType%
  set StepNum=1
  call :Trim %TempTrim%
:Step1
  set DefaultType=%TempTrim%
  for /f "tokens=2 delims==" %%d in ('findstr "DefaultLocation=" defaults.dat') do set "DefaultLocation=%%d"
  set TempTrim=%DefaultLocation%
  set StepNum=2
  call :Trim %TempTrim%
:Step2
  set DefaultLocation=%TempTrim%
  for /f "tokens=2 delims==" %%e in ('findstr "DefaultName=" defaults.dat') do set "DefaultName=%%e"
  set TempTrim=%DefaultName%
  set StepNum=3
  call :Trim %TempTrim%
:Step3
  set DefaultName=%TempTrim%

:Start
  call 
  cls
  type "main.dat"
  echo:
  choice /c 12345 /n /t 30 /d 5 /m "Choose an option to continue:"
  if %ERRORLEVEL%==5 exit
  if %ERRORLEVEL%==4 goto Update
  if %ERRORLEVEL%==3 goto Settings
  if %ERRORLEVEL%==2 goto Search
  if %ERRORLEVEL%==1 goto Download
  exit

:Download
  call 
  cls
  type "download.dat"
  echo:
  set /p YtLink=Paste link or ID from video sharing site: 
  set /p FileType=Choose a file type (mp3, m4a, mp4, webm, etc.) or push ENTER for default [Default type: %DefaultType%] 
  if [%FileType%]==[] set FileType=%DefaultType%
  if %DefaultLocation%==%%downloads%% set "DefaultLocation=Downloads"
  set /p FileLocate=Set a destination for downloaded file or push ENTER for default location [Default location: %DefaultLocation%] 
  if %DefaultLocation%==Downloads set "DefaultLocation=%%downloads%%"
  if [%FileLocate%]==[] set FileLocate=%DefaultLocation%
  set /p FileName="Set a name for the file or push ENTER for default [Default name: %DefaultName%.%DefaultType%] "
  if ["%FileName%"]==[] set FileName=%DefaultName%
  .\yt-dlp -o "%FileName%".%%(ext)s -P "%FileLocate%" -f %FileType% %YtLink%
  choice /c YN /n /m "Download another video? (Y or N)"
  if %ERRORLEVEL%==2 goto Start
  if %ERRORLEVEL%==1 goto Download

:Search
  call 
  cls
  type "search.dat"
  echo:
  set /p SearchTerm=Choose a term to search for on Youtube.com: 
  .\yt-dlp ytsearch5:"%SearchTerm%" --get-id --get-title
  choice /c YN /n /m "Search for another term? (Y or N)"
  if %ERRORLEVEL%==2 goto Start
  if %ERRORLEVEL%==1 goto Search

:Settings
  call 
  cls
  type "settings.dat"
  echo:
  choice /c 12345 /n /m "Choose an option to continue:"
  if %ERRORLEVEL%==5 goto Save
  if %ERRORLEVEL%==4 goto RestoreDef
  if %ERRORLEVEL%==3 goto DefName
  if %ERRORLEVEL%==2 goto DefLocation
  if %ERRORLEVEL%==1 goto DefType

:DefType
  cls
  set TempType=%DefaultType%
  echo Current Default Type: %DefaultType%
  set /p DefaultType=What would you like to change the Default Type to? (Do not put a . before the file type): 
  choice /c YN /n /m "Is this correct: %DefaultType%? (Y or N)"
  if %ERRORLEVEL%==2 set DefaultType=%TempType% & goto DefType
  if %ERRORLEVEL%==1 goto Settings

:DefLocation
  cls
  set TempLocation=%DefaultLocation%
  if %DefaultLocation%==%%downloads%% set "DefaultLocation=Downloads"
  echo Current Default Location: %DefaultLocation%
  set /p DefaultLocation=What would you like to change the Default Location to? (Must be in C:\example\folder format): 
  choice /c YN /n /m "Is this correct: %DefaultLocation%? (Y or N)"
  if %DefaultLocation%==Downloads set "DefaultLocation=%%downloads%%"
  if %ERRORLEVEL%==2 set DefaultLocation=%TempLocation% & goto DefLocation
  if %ERRORLEVEL%==1 goto Settings

:DefName
  cls
  set TempName=%DefaultName%
  echo Current Default Name: %DefaultName%
  set /p DefaultName=What would you like to change the Default Name to?: 
  choice /c YN /n /m "Is this correct: %DefaultName%? (Y or N)"
  if %ERRORLEVEL%==2 set DefaultName=%TempName% & goto DefName
  if %ERRORLEVEL%==1 goto Settings

:RestoreDef
  cls
  choice /c YN /n /m "Are you sure you would like to restore defaults to their original state? (Y or N)"
  if %ERRORLEVEL%==2 goto Settings
  if %ERRORLEVEL%==1 echo DefaultType=mp4 > "defaults.dat"
  echo DefaultLocation=%%downloads%% >> "defaults.dat"
  echo DefaultName=downloadedcontent >> "defaults.dat"
  goto Settings

:Save
  set SaveType=0
  set ExitType=0
  cls
  type "save.dat"
  echo:
  choice /c 1234 /n /m "Choose an option to continue:"
  if %ERRORLEVEL%==4 set ExitType=1 && goto ExitSetMain
  if %ERRORLEVEL%==3 goto ExitSetMain
  if %ERRORLEVEL%==2 set SaveType=1 && goto SaveSetMain
  if %ERRORLEVEL%==1 goto SaveSetMain

:SaveSetMain
  cls
  choice /c YN /n /m "Are you sure you would like to save? (Y or N)"
  if %ERRORLEVEL%==2 goto Save
  if %ERRORLEVEL%==1 echo DefaultType=%DefaultType% > "defaults.dat"
  echo DefaultLocation=%DefaultLocation% >> "defaults.dat"
  echo DefaultName=%DefaultName% >> "defaults.dat"
  if %SaveType%==1 goto Settings
  goto Start

:ExitSetMain
  cls
  choice /c YN /n /m "Are you sure you would like to exit? (Y or N)"
  if %ERRORLEVEL%==2 goto Save
  if %ERRORLEVEL%==1 set DefaultType=%TempType%
  set DefaultLocation=%TempLocation%
  set DefaultName=%TempName%
  if %ExitType%==1 goto Settings
  goto Start

:Update
  call 
  cls
  .\yt-dlp -U
  pause
  goto Start

:Trim
  set TempTrim=%*
  goto Step%StepNum%