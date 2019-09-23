@echo OFF
echo Administrative permissions required. Detecting permissions...
net session >nul 2>&1
if %errorLevel% == 0 (
   	echo Success: Administrative permissions confirmed.
) else (
	echo Failure: Please run this script from within an Admin Shell!
	pause
	exit /B 1
)
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
cd /d %~dp0
<nul set /p ver=<version.txt
set title=%~n0
set "p_out=patches_out"
set "d_out=decompile_out"
set "s_out=source"
set "a_out=__MODDED_APK_OUT__"
set pCounter=1
set "keepSource=delete"
set "lang=false"
set FilePersist=%~dpn0+.cmd&     rem --define the filename where persistent variables get stored
rd /S /Q %p_out% >nul 2>&1
rd /S /Q %d_out% >nul 2>&1
rd /S /Q %a_out% >nul 2>&1
:chks
call:chkinst "PutApkHere\orig.apk"
call:chkinst "tools\apktool.jar"
call:chkinst "tools\bspatch.exe"
call:chkinst "tools\patch.exe"
call:chkinst "tools\apksigner\apksigner.jar"
for /F "usebackq" %%A IN ('PutApkHere\orig.apk') do set size=%%~zA
for /f "tokens=*" %%a in ('findstr %size% patches\versions.txt') do set _CmdResult=%%a
for /F "tokens=1 delims=:" %%a in ("%_CmdResult%") do (
   set "goVers=%%a"
   set "vers=%ver% !goVers!"
   set "patches=patches\!goVers!"
)
if "%_CmdResult%" == "" ( echo.-: Unrecognized apk file.
 pause
 exit )
for /f "tokens=1,* delims=. " %%F in ('dir /b %patches%\*.patch') do (
 set "newvar=%%F"
 set !newvar!_choice=,Yes,No,
 call:setPersist "!newvar!=No" )
call:restorePersistentVars "%FilePersist%"
java -version >nul 2>&1 && ( GOTO:menuLOOP
 ) || ( call )
javac -version >nul 2>&1 && ( GOTO:menuLOOP
 ) || ( echo.-: Java not installed...
 pause
 exit )
:menuLOOP
cls
echo.
TITLE DeeJayEYE Patcher v%vers%
REM [!%newvar%_choice:~1,-1!] vewy speshul
for /f "tokens=1,* delims=. " %%X in ('dir /b %patches%\*.patch') do (
 set "pC= [!pCounter!]"
 set "pX=!%%X! "
 set "stringy='%%X'                                              "
 set "scan=  !pC:~-4! !pX:~0,3! !stringy:~0,52!"
 if !pCounter! == 1 ( echo.!scan![P]atch apk
  ) else if !pCounter! == 2 ( echo.!scan![S]ource: !keepSource!
  ) else if !pCounter! == 3 ( echo.!scan![R]eadme
  ) else if !pCounter! == 4 ( echo.!scan![D]escriptions
  ) else if !pCounter! == 5 ( echo.!scan![L]anguages: !lang!
  ) else echo.!scan!
 set patch!pCounter!=%%X
 set /a pCounter=!pCounter!+1 )
REM color 08
call:sleep 1
REM color 07
set /a pCounter=22-!pCounter!
FOR /l %%i in (1,1,!pCounter!) do echo.
set pCounter=1
set choice=
echo.&set /p choice=-: [ENTER] choice: ||(
 call:savePersistentVars "%FilePersist%"&   rem --save the persistent variables to the storage
 GOTO:EOF )
echo.%choice%| findstr /r "^[1-9][0-9]*$">nul
if %errorlevel% equ 0 (	echo.&call:menu_PM
 ) else echo.&call:menu_%choice%
GOTO:menuLOOP
:menu_PM
call:getNextInList !patch%choice%! "!%newvar%_choice!"
cls
GOTO:EOF
:menu_S - toggle decompiled source retention
if !keepSource!==keep (set keepSource=remove) else (set keepSource=keep)
goto:eof
:menu_R - View readme
cls
more /E Readme.md
pause
GOTO:EOF
:menu_D - View patch descriptions
cls
more /E Patch-Descriptions.txt
pause
GOTO:EOF
:menu_L - Add additonal languages if present
if !lang!==true (set lang=false) else (set lang=true)
cls
goto:EOF
:menu_P - Start Patching
md %a_out%
md %p_out%
cls
echo.
echo.-: Converting patches...
rename "%patches%\origin" origin.patch
for /f "tokens=*" %%f in ('dir /b %patches%\*.patch') do ( copy %patches%\%%f %p_out%\%%f.copy >nul
 TYPE "%p_out%\%%f.copy" | MORE /E /P > "%p_out%\%%f"
 del /f /q %p_out%\%%f.copy )
rename "%patches%\origin.patch" origin
echo.-: Decompiling original apk...
java -jar tools\apktool.jar d -o %d_out% PutApkHere\orig.apk
if !lang!==true (
  echo.-: Copy additional languages ...
  xcopy %patches%\lang %d_out%\res\ /s /e /i
)
cd %d_out%
..\tools\patch  -l -s -p1 -N -r - < ..\%p_out%\origin.patch
if exist "..\%patches%\so2.bspatch" (
..\tools\bspatch lib\armeabi-v7a\libFREncrypt.so lib\armeabi-v7a\libFREncrypt-n.so ..\%patches%\so2.bspatch"
del /f /q "lib\armeabi-v7a\libFREncrypt.so"
rename "lib\armeabi-v7a\libFREncrypt-n.so" libFREncrypt.so )
for /f "tokens=1,* delims=. " %%f in ('dir /b ..\%p_out%\*.patch') do ( if /i "!%%f:~0,1!"=="Y" ( echo.-: Applying %%f patch...
  ..\tools\patch  -l -s -p1 -N -r - < ..\%p_out%\%%f.patch
  if "%%f"=="removeOnlinefunction" ( echo.-: Supporting with so.bspatch...
   ..\tools\bspatch lib\armeabi-v7a\libSDKRelativeJNI.so lib\armeabi-v7a\libSDKRelativeJNI-n.so ..\%patches%\so.bspatch"
   del /f /q "lib\armeabi-v7a\libSDKRelativeJNI.so"
   rename "lib\armeabi-v7a\libSDKRelativeJNI-n.so" libSDKRelativeJNI.so )
   if "%%f"=="removeNFZ_ApplicationPart" ( echo.-: Deleting all NFZ db all files...
   del /f /q "assets\expansion\internal\flysafe\dji.nfzdb.confumix"
   del /f /q "assets\expansion\internal\flysafe\dji.nfzdb.sig"
   del /f /q "assets\expansion\internal\flysafe\flysafe_areas_djigo.db"
   del /f /q "assets\expansion\internal\flysafe\flysafe_polygon_1860.db"
   del /f /q "assets\expansion\internal\flysafe\flyforbid_airmap\*.json"
   del /f /q "res\raw\flyforbid.json"
   copy /b NUL "res\raw\flyforbid.json" ) ) )
REM nothing
REM here
cd ..
echo.-: Rebuilding apk...
java -jar tools\apktool.jar b -o %a_out%\mod.apk %d_out%
echo.-: Signing with testkey...
java -jar tools\apksigner\apksigner.jar sign --key tools\apksigner\testkey.pk8 --cert tools\apksigner\testkey.x509.pem %a_out%\mod.apk
move %a_out%\mod.apk %a_out%\mod-%ver%.apk >nul
echo.-: Cleaning up...
if !keepSource!==keep (
   if not exist %s_out% (mkdir %s_out%)
   for /f "usebackq tokens=2,3,4,5,6,7 delims=/:. " %%g in (`echo %DATE% %TIME%`) do (
   	   set y=%%i
   	   set stamp=%%g%%h%y:~2,2%%%j%%k%%l
   )
   move %d_out% %s_out%\%goVers%-%stamp%
   echo.-:    Patched source saved in %s_out%\%goVers%-%stamp%
) else (
   echo.-:    Deleting decompiled source...
   rd /S /Q %d_out%)
echo.-:    Deleting selected patches cache... & rd /S /Q %p_out%
echo.-: Have fun and stay safe
pause
exit
::-----------------------------------------------------------
:: helpers here
::-----------------------------------------------------------
:sleep :: -- waits some seconds before returning
::        -- %~1 – in, number of seconds to wait
FOR /l %%a in (%~1,-1,1) do (ping -n 2 -w 1 127.0.0.1>NUL)
GOTO:EOF
:chkinst -- check for required items
::                 -- %~1: the tool, whodathunkit
if exist %~1 ( call
 ) else (
 echo.-: Could not find '%~1'...
 echo.-: Press any key to resume...
 pause >nul
 GOTO:chks )
GOTO:EOF
:setPersist -- to be called to initialize persistent variables
::          -- %*: set command arguments
set %*
GOTO:EOF
:getPersistentVars -- returns a comma separated list of persistent variables
::                 -- %~1: reference to return variable
SETLOCAL
set retlist=
for /f "tokens=1,* delims=. " %%F in ('dir /b %patches%\*.patch') do (set retlist=!retlist!%%F,)
( ENDLOCAL & REM RETURN VALUES
    IF "%~1" NEQ "" SET %~1=%retlist% )
GOTO:EOF
:savePersistentVars -- Save values of persistent variables into a file
::                  -- %~1: file name
SETLOCAL
echo.>"%~1"
call :getPersistentVars persvars
for %%a in (%persvars%) do (echo.SET %%a=!%%a!>>"%~1")
GOTO:EOF
:restorePersistentVars -- Restore the values of the persistent variables
::                     -- %~1: batch file name to restore from
if exist "%FilePersist%" call "%FilePersist%"
GOTO:EOF
:getNextInList -- return next value in list
::             -- %~1 - in/out ref to current value, returns new value
::             -- %~2 - in     choice list, must start with delimiter which must not be '@'
SETLOCAL
set lst=%~2&             rem.-- get the choice list
if "%lst:~0,1%" NEQ "%lst:~-1%" echo.ERROR Choice list must start and end with the delimiter&GOTO:EOF
set dlm=%lst:~-1%&       rem.-- extract the delimiter used
set old=!%~1!&           rem.-- get the current value
set fst=&for /f "delims=%dlm%" %%a in ("%lst%") do set fst=%%a&rem.--get the first entry
                         rem.-- replace the current value with a @, append the first value
set lll=!lst:%dlm%%old%%dlm%=%dlm%@%dlm%!%fst%%dlm%
                         rem.-- get the string after the @
for /f "tokens=2 delims=@" %%a in ("%lll%") do set lll=%%a
                         rem.-- extract the next value
for /f "delims=%dlm%" %%a in ("%lll%") do set new=%%a
( ENDLOCAL & REM RETURN VALUES
    IF "%~1" NEQ "" (SET %~1=%new%) ELSE (echo.%new%) )
GOTO:EOF
