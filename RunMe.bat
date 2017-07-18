@ECHO OFF
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
cd /d %~dp0
set /p ver=<version.txt
set title=%~n0
TITLE %title%
for /f "tokens=1,* delims=. " %%F in ('dir /b patches\*.patch') do (
	set "newvar=%%F"
	set %newvar%_choice=,Yes,No,
	call:setPersist "!newvar!=Yes"
	)
set "p_out=patches_out"
set "d_out=decompile_out"
set "a_out=_NEW_APK"
rd /S /Q %p_out% >nul 2>&1
rd /S /Q %d_out% >nul 2>&1
rd /S /Q %a_out% >nul 2>&1
set pCounter=1
for /f "tokens=1,* delims=. " %%F in ('dir /b patches\*.patch') do (
	set "newvar=%%F"
	set %newvar%_choice=,Yes,No,
	call:setPersist "!newvar!=No"
	)
:menuLOOP
echo.
echo.-:=========================[ DeeJayEYE Patcher v%ver% ]==========================:-
echo.  Options:
for /f "tokens=1,* delims=. " %%X in ('dir /b patches\*.patch') do (
		set "newvar=%%X"
		echo. [!pCounter!] '!%%X!' %%X
		REM [!%newvar%_choice:~1,-1!] speshul
		set patch!pCounter!=%%X
		set /a pCounter=!pCounter!+1
		)
	color 08
	call:sleep 1
	color 07
	set pCounter=1
	echo.
	echo.  Help:
	echo. [R]eadme
	echo. [D]escriptions
	echo.
	echo.  Execute:
	echo. [P]atch apk
	set choice=
	echo.&set /p choice=-: [ENTER] choices: ||(
    GOTO:EOF
	)
cls
echo %choice%| findstr /r "^[1-9][0-9]*$">nul
if %errorlevel% equ 0 (
	echo.&call:menu_PM
	) else echo.&call:menu_%choice%
GOTO:menuLOOP
:menu_PM
call:getNextInList !patch%choice%! "!%newvar%_choice!"
cls
GOTO:EOF
:menu_R - View readme
more Readme.md
cls
GOTO:EOF
:menu_D - View patch descriptions
more Patch-Descriptions.txt
cls
GOTO:EOF
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
for /f "tokens=1,* delims=. " %%f in ('dir /b ..\%p_out%\*.patch') do (
	if /i "!%%f:~0,1!"=="Y" (
		echo -: Applying %%f patch...
		..\tools\patch  -l -s -p1 -N -r - < ..\%p_out%\%%f.patch
			if "%%f"=="removeOnlinefunction" (
			echo -: Applying so.bspatch...
			..\tools\bspatch lib\armeabi-v7a\libSDKRelativeJNI.so lib\armeabi-v7a\libSDKRelativeJNI-n.so ..\patches\so.bspatch
			del /f /q "lib\armeabi-v7a\libSDKRelativeJNI.so"
			rename "lib\armeabi-v7a\libSDKRelativeJNI-n.so" libSDKRelativeJNI.so
			)
		)
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
:sleep -– waits some seconds before returning
::     -- %~1 – in, number of seconds to wait
FOR /l %%a in (%~1,-1,1) do (ping -n 2 -w 1 127.0.0.1>NUL)
GOTO:EOF
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