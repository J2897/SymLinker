:: Released under the GNU General Public License version 3 by J2897.

@echo OFF
pushd "%~dp0"
title SymLinker

ver | find "Version 6." > nul
if %ERRORLEVEL% == 0 (
	REM Do OPENFILES to check for administrative privileges
	openfiles > nul
	if errorlevel 1 (
		color cf
		echo.
		echo Right-click on this file and select 'Run as administrator'.
		echo.
		pause
		exit /b 1
	)
)

color 1b
set PYTHON=C:\Python27\python.exe

if not exist %PYTHON% (
	echo This program requires Python 2.7.* to be installed.
	echo.
	pause
) && (goto :End)

set PROC_FOLDERS_PY="%CD%\proc_folders.py"
set PROC_FILES_PY="%CD%\proc_files.py"
set "RETURN=Press any key to return to the menu . . ."

:Start
cls
echo.
echo  1. Scan file-system for symbolic links.
echo  2. Create 'soft' symbolic links.
echo  3. Create 'hard' symbolic links.
echo  4. Exit.
echo.
choice /C:1234 /T 300 /D 4 /M "Which number"
if ERRORLEVEL 4 goto :End
if ERRORLEVEL 3 goto :Create_Hard_Links
if ERRORLEVEL 2 goto :Create_Soft_Links
if ERRORLEVEL 1 goto :Scan_FS

:Scan_FS
cls
echo Scanning . . .
echo.
set SL_TXT=Symbolic Links.txt
Set i=0
:Next_Name
	if not exist "%USERPROFILE%\Desktop\%SL_TXT%" (goto :Start_Scanning)
	set /A i+=1
	set SL_TXT=Symbolic Links (%i%).txt
	goto :Next_Name
:Start_Scanning
dir /al /s "%CD:~0,3%" > "%USERPROFILE%\Desktop\%SL_TXT%"
echo Log: "%USERPROFILE%\Desktop\%SL_TXT%"
echo.
start /i %windir%\system32\notepad.exe "%USERPROFILE%\Desktop\%SL_TXT%"
echo %RETURN%
pause > nul
goto :Start

:Create_Soft_Links
set MKLINK=mklink
goto :Source_Input

:Create_Hard_Links
set MKLINK=mklink /h

:Source_Input
REM If a folder parameter was passed as the Source, skip the user input.
if not "%1"=="" (set SOURCE=%1) && (goto :Skip_Source_Input)

cls
echo Enter the full path to the source folder without quotes:
echo.
echo    OK - C:\Source
echo.
echo    Not OK - "C:\Source"
echo.
echo.
echo Try right-clicking this window and pasting it in:
echo.
echo    Edit ^> Paste
echo.
echo.
set /p "SOURCE=Enter path: "
:Skip_Source_Input

REM Check user input...

	REM If nothing was entered, try again.
	if not defined SOURCE (set SOURCE=) && (goto :Source_Input)
	
	REM make sure that the second and third digits are ":\".
	if %SOURCE:~1,2% NEQ :\ (set SOURCE=) && (goto :Source_Input)
	
	REM Is there a trailing slash? if so, remove it.
	if %SOURCE:~-1%==\ (set SOURCE=%SOURCE:~0,-1%)

REM Make sure the folder exists.
if not exist "%SOURCE%" (
	echo.
	echo Folder not found:	%SOURCE%
	echo.
	pause
	set SOURCE=
	goto :Source_Input
)

REM Add double-quotes to the Source variable.
set SOURCE=^"%SOURCE%^"

:Destination_Input
cls
echo Source accepted: %SOURCE%
echo.
echo And finally, enter the path to the destination:
echo.
echo    OK - C:\Dest
echo.
echo    Not OK - "C:\Dest"
echo.
echo.
echo Or just press Enter to accept the default path: %CD:~0,3%Symlinks
echo.
set /p "DESTINATION=Enter path: "
cls

REM Check user input...

	REM Default destination.
	if not defined DESTINATION (set DESTINATION=%CD:~0,3%Symlinks)

	REM make sure that the second and third digits are ":\".
	if %DESTINATION:~1,2% NEQ :\ (set DESTINATION=) && (goto :Destination_Input)

	REM Is there a trailing slash? if so, remove it.
	if %DESTINATION:~-1%==\ (set DESTINATION=%DESTINATION:~0,-1%)

REM Add double-quotes to the Destination variable.
set DESTINATION=^"%DESTINATION%^"

if exist %DESTINATION% (
	echo Destination already exists:
	echo.
	echo 	%DESTINATION%
	echo.
	echo Are you sure it's safe to proceeed?
	echo.
	pause
	cls
)

set FOLDER_LIST="%TEMP%\folder_list.tmp"
set FILE_LIST="%TEMP%\file_list.tmp"
set FOLDER_STRUCTURE="%TEMP%\folder_structure.tmp"
set FILE_STRUCTURE="%TEMP%\file_structure.tmp"

echo Generating folder list . . .
dir /a:d /b /s %SOURCE% > %FOLDER_LIST%

REM If the Folder List file is empty, add the Source folder only.
for %%r in (%FOLDER_LIST%) do if %%~zr EQU 0 (echo %SOURCE:"=%> %FOLDER_LIST%)

REM Pass the Source, Destination and Folder List, over to the proc_folders.py file.
if exist %FOLDER_STRUCTURE% (del %FOLDER_STRUCTURE%)
echo Passing the folder list over to Python . . .
%PYTHON% %PROC_FOLDERS_PY% %SOURCE% %DESTINATION% %FOLDER_LIST%
del %FOLDER_LIST%

REM Create the folders from the Folder Structure file.
echo Creating folders from the folder structure . . .
for /f "delims=" %%a in ('type "%FOLDER_STRUCTURE%"') do (md "%%a")
del %FOLDER_STRUCTURE%

REM Generate File List.
echo Generating file list . . .
dir /a:-d /b /s %SOURCE% > %FILE_LIST%

REM Pass the Source, Destination and File List, over to the proc_files.py file.
if exist %FILE_STRUCTURE% (del %FILE_STRUCTURE%)
echo Passing the file list over to Python . . .
%PYTHON% %PROC_FILES_PY% %SOURCE% %DESTINATION% %FILE_LIST%
del %FILE_LIST%

REM Create the symbolic links from the File Structure file.
echo Creating symbolic links from the file structure . . .
for /f "delims=" %%a in ('type "%FILE_STRUCTURE%"') do (%MKLINK% %%a >> "%USERPROFILE%\Desktop\Symlinks Created.txt")
del %FILE_STRUCTURE%

echo.
echo Done.
echo.
echo %RETURN%
pause > nul
goto :Start

:End
color
popd
