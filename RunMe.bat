@echo OFF
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
cd /d %~dp0
<nul set /p ver=<version.txt
set title=%~n0
set "p_out=patches_out"
set "d_out=decompile_out"
set "a_out=_NEW_APK"
set aV414s=94569319
set aV413s=104544384
set pCounter=1
set FilePersist=%~dpn0+.cmd&     rem --define the filename where persistent variables get stored
rd /S /Q %p_out% >nul 2>&1
rd /S /Q %d_out% >nul 2>&1
rd /S /Q %a_out% >nul 2>&1
:chks
call:chkinst "PutApkHere\orig.apk"
call:chkinst "tools\apktool.jar"
call:chkinst "tools\bspatch.exe"
call:chkinst "tools\patch.exe"
call:chkinst "tools\sign.jar"
for /F "usebackq" %%A IN ('PutApkHere\orig.apk') do set size=%%~zA
if %size% == %aV413s% ( set "patches=patches\4.1.3"
 set "vers=%ver% (4.1.3)"
 ) else if %size% == %aV414s% ( set "patches=patches\4.1.4"
 set "vers=%ver% (4.1.4)"
 ) else ( echo.-: Unrecognized apk file.
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
  ) else if !pCounter! == 3 ( echo.!scan![R]eadme
  ) else if !pCounter! == 4 ( echo.!scan![D]escriptions
  ) else echo.!scan!
 set patch!pCounter!=%%X
 set /a pCounter=!pCounter!+1 )
color 08
call:sleep 1
color 07
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
:menu_R - View readme
cls
more Readme.md
pause
GOTO:EOF
:menu_D - View patch descriptions
cls
more Patch-Descriptions.txt
pause
GOTO:EOF
:menu_P - Start Patching
md %a_out%
md %p_out%
cls
echo.
echo.-: Converting patches...
rename "%patches%\origin" origin.patch
for /f "tokens=*" %%f in ('dir /b %patches%\*.patch') do ( copy %patches%\%%f %p_out%\%%f.copy >nul
 TYPE "%p_out%\%%f.copy" | MORE /P > "%p_out%\%%f"
 del /f /q %p_out%\%%f.copy )
rename "%patches%\origin.patch" origin
echo.-: Decompiling original apk...
java -jar tools\apktool.jar d -o %d_out% PutApkHere\orig.apk
cd %d_out%
..\tools\patch  -l -s -p1 -N -r - < ..\%p_out%\origin.patch
for /f "tokens=1,* delims=. " %%f in ('dir /b ..\%p_out%\*.patch') do ( if /i "!%%f:~0,1!"=="Y" ( echo.-: Applying %%f patch...
  ..\tools\patch  -l -s -p1 -N -r - < ..\%p_out%\%%f.patch
  if "%%f"=="removeOnlinefunction" ( echo.-: Supporting with so.bspatch...
   ..\tools\bspatch lib\armeabi-v7a\libSDKRelativeJNI.so lib\armeabi-v7a\libSDKRelativeJNI-n.so ..\%patches%\so.bspatch"
   del /f /q "lib\armeabi-v7a\libSDKRelativeJNI.so"
   rename "lib\armeabi-v7a\libSDKRelativeJNI-n.so" libSDKRelativeJNI.so ) ) )
REM nothing
REM here
cd ..
echo.-: Rebuilding apk...
java -jar tools\apktool.jar b -o %a_out%\mod.apk %d_out%
echo.-: Signing with testkey...
java -jar tools\sign.jar %a_out%\mod.apk
del /f /q %a_out%\mod.apk
move %a_out%\mod.s.apk %a_out%\mod-%ver%.apk >nul
echo.-: Cleaning up...
rd /S /Q %d_out%
rd /S /Q %p_out%
echo.-: Have fun and stay safe
pause
exit
::-----------------------------------------------------------
:: helpers here
::-----------------------------------------------------------
:sleep -– waits some seconds before returning
::     -- %~1 – in, number of seconds to wait
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
