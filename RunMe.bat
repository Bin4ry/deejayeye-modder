@ECHO OFF
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
cd /d %~dp0
set /p ver=<version.txt
set "p_out=patches_out"
set "d_out=decompile_out"
set "a_out=_NEW_APK"
rd /S /Q %p_out% >nul 2>&1
rd /S /Q %d_out% >nul 2>&1
rd /S /Q %a_out% >nul 2>&1
set title=%~n0
TITLE %title%
set FilePersist=%~dpn0+.cmd&
set             forceFCC_choice=,Yes,No,
call:setPersist forceFCC=No
set             removeUpdateForce_choice=,Yes,No,
call:setPersist removeUpdateForce=No
set             removeFWUpgradeService_choice=,Yes,No,
call:setPersist removeFWUpgradeService=No
set             offlineLogin_choice=,Yes,No,
call:setPersist offlineLogin=No
set             removeOnlinefunction_choice=,Yes,No,
call:setPersist removeOnlinefunction=No
set             removeGoogleApis_choice=,Yes,No,
call:setPersist removeGoogleApis=No
set             removeSocial_choice=,Yes,No,
call:setPersist removeSocial=No
set             enableP3series_choice=,Yes,No,
call:setPersist enableP3series=No
set             enableMavicFlightModesOnSpark_choice=,Yes,No,
call:setPersist enableMavicFlightModesOnSpark=No
call:restorePersistentVars "%FilePersist%"
:menuLOOP
echo.
echo. =========================== DeeJayEYE Patcher v%ver% ============================
echo.
call:check_Permissions
for /f "tokens=1,2,* delims=_ " %%A in ('"findstr /b /c:":menu_" "%~f0""') do echo.  %%B  %%C
set choice=
echo.&set /p choice=-: Choose patches or hit ENTER to quit: ||(
    call:savePersistentVars "%FilePersist%"&   rem --save
    GOTO:EOF
)
echo.&call:menu_%choice%
GOTO:menuLOOP
:menu_Options:
:menu_1 - forceFCC                                '!forceFCC!' [!forceFCC_choice:~1,-1!]
call:getNextInList forceFCC "!forceFCC_choice!"
cls
GOTO:EOF
:menu_2 - removeUpdateForce                       '!removeUpdateForce!' [!removeUpdateForce_choice:~1,-1!]
call:getNextInList removeUpdateForce "!removeUpdateForce_choice!"
cls
GOTO:EOF
:menu_3 - removeFWUpgradeService                  '!removeFWUpgradeService!' [!removeFWUpgradeService_choice:~1,-1!]
call:getNextInList removeFWUpgradeService "!removeFWUpgradeService_choice!"
cls
GOTO:EOF
:menu_4 - offlineLogin                            '!offlineLogin!' [!offlineLogin_choice:~1,-1!]
call:getNextInList offlineLogin "!offlineLogin_choice!"
cls
GOTO:EOF
:menu_5 - removeOnlinefunction                    '!removeOnlinefunction!' [!removeOnlinefunction_choice:~1,-1!]
call:getNextInList removeOnlinefunction "!removeOnlinefunction_choice!"
cls
GOTO:EOF
:menu_6 - removeGoogleApis                        '!removeGoogleApis!' [!removeGoogleApis_choice:~1,-1!]
call:getNextInList removeGoogleApis "!removeGoogleApis_choice!"
cls
GOTO:EOF
:menu_7 - removeSocial                            '!removeSocial!' [!removeSocial_choice:~1,-1!]
call:getNextInList removeSocial "!removeSocial_choice!"
cls
GOTO:EOF
:menu_8 - enableMavicFlightModesOnSpark           '!enableMavicFlightModesOnSpark!' [!enableMavicFlightModesOnSpark_choice:~1,-1!]
call:getNextInList enableMavicFlightModesOnSpark "!enableMavicFlightModesOnSpark_choice!"
cls
GOTO:EOF
:menu_9 - enableP3series                          '!enableP3series!' [!enableP3series_choice:~1,-1!]
call:getNextInList enableP3series "!enableP3series_choice!"
cls
GOTO:EOF
:menu_
:menu_Help:
:menu_R - View readme
notepad Readme.md
cls
GOTO:EOF
:menu_D - View patch descriptions
notepad Patch-Descriptions.txt
cls
GOTO:EOF
:menu_
:menu_Execute:
:menu_P - Start Patching
md %a_out%
md %p_out%
echo -: Converting patches...
for /f "tokens=*" %%f in ('dir /b patches\*.patch') do (
	copy patches\%%f %p_out%\%%f.copy >nul
	TYPE "%p_out%\%%f.copy" | MORE /P > "%p_out%\%%f"
	del /f /q %p_out%\%%f.copy
	)
echo -: Decompiling original apk...
IF EXIST PutApkHere\orig.apk (
	java -jar tools\apktool.jar d -o %d_out% PutApkHere\orig.apk
	) ELSE (
	echo -:
	echo -: FATAL ERROR '\PutApkHere\orig.apk' NOT FOUND
	echo -:
	pause
	exit
	)
cd %d_out%
if /i "%forceFCC:~0,1%"=="Y" (
	echo -: Applying forceFCC patch...
	..\tools\patch  -l -s -p1 -N -r - < ..\%p_out%\forceFCC.patch
	)
if /i "%removeUpdateForce:~0,1%"=="Y" (
	echo -: Applying removeUpdateForce patch...
	..\tools\patch  -l -s -p1 -N -r - < ..\%p_out%\removeUpdateForce.patch
	)
if /i "%removeFWUpgradeService:~0,1%"=="Y" (
	echo -: Applying removeFWUpgradeService patch...
	..\tools\patch  -l -s -p1 -N -r - < ..\%p_out%\removeFWUpgradeService.patch
	)
if /i "%offlineLogin:~0,1%"=="Y" (
	echo -: Applying offlineLogin patch...
	..\tools\patch  -l -s -p1 -N -r - < ..\%p_out%\offlineLogin.patch
	)
if /i "%removeOnlinefunction:~0,1%"=="Y" (
	echo -: Applying removeOnlinefunction.patch and so.bspatch...
	..\tools\bspatch lib\armeabi-v7a\libSDKRelativeJNI.so lib\armeabi-v7a\libSDKRelativeJNI-n.so ..\patches\so.bspatch
	del /f /q "lib\armeabi-v7a\libSDKRelativeJNI.so"
	rename "lib\armeabi-v7a\libSDKRelativeJNI-n.so" libSDKRelativeJNI.so
	..\tools\patch -l -s -p1 -N -r - < ..\%p_out%\removeOnlinefunction.patch
	)
if /i "%removeGoogleApis:~0,1%"=="Y" (
	echo -: Applying removeGoogleApis patch...
	..\tools\patch  -l -s -p1 -N -r - < ..\%p_out%\removeGoogleApis.patch
	)
if /i "%removeSocial:~0,1%"=="Y" (
	echo -: Applying removeSocial patch...
	..\tools\patch  -l -s -p1 -N -r - < ..\%p_out%\removeSocial.patch
	)
if /i "%enableP3series:~0,1%"=="Y" (
	echo -: Applying enableP3series patch...
	..\tools\patch  -l -s -p1 -N -r - < ..\%p_out%\enableP3series.patch
	)
if /i "%enableMavicFlightModesOnSpark:~0,1%"=="Y" (
	echo -: Applying enableMavicFlightModesOnSpark patch...
	..\tools\patch  -l -s -p1 -N -r - < ..\%p_out%\enableMavicFlightModesOnSpark.patch
	)
del /f /q "assets\terms\en\DJI_Go_4_App_Terms_of_Use.html"
copy "..\patches\unknown.lol" "assets\terms\en\DJI_Go_4_App_Terms_of_Use.html" >nul
REM nothing
REM here
cd ..
echo -: Rebuilding apk...
java -jar tools\apktool.jar b -o %a_out%\mod.apk %d_out%
echo -: Signing with testkey...
java -jar tools\sign.jar %a_out%\mod.apk
del /f /q %a_out%\mod.apk
move %a_out%\mod.s.apk %a_out%\mod-%ver%.apk >nul
echo -: Cleaning up...
rd /S /Q %d_out%
rd /S /Q %p_out%
echo -: "Have fun and stay safe!"
pause
exit
GOTO:EOF
::-----------------------------------------------------------
:: helpers here
::-----------------------------------------------------------
:setPersist -- to be called to initialize persistent variables
::          -- %*: set command arguments
set %*
GOTO:EOF
:getPersistentVars -- returns a comma separated list of persistent variables
::                 -- %~1: reference to return variable 
SETLOCAL
set retlist=
set parse=findstr /i /c:"call:setPersist" "%~f0%"^|find /v "ButNotThisLine"
for /f "tokens=2 delims== " %%a in ('"%parse%"') do (set retlist=!retlist!%%a,)
( ENDLOCAL & REM RETURN VALUES
    IF "%~1" NEQ "" SET %~1=%retlist%
)
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
    IF "%~1" NEQ "" (SET %~1=%new%) ELSE (echo.%new%)
)
GOTO:EOF
:check_Permissions
net session >nul 2>&1
if not %errorLevel% == 0 (
    echo Error: Script requires administrator permissions. Press any key to exit, and relaunch with "Run as administrator".
    pause >nul
    exit
)
GOTO:EOF
