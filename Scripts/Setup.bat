@echo off

setlocal ENABLEDELAYEDEXPANSION

set "SCRIPT_PATH=%~dp0"

rem research of vcpkg
call "%SCRIPT_PATH%\Vcpkg\VcpkgSearch.bat"

if %ERRORLEVEL% EQU 1 (
	call "%SCRIPT_PATH%\Vcpkg\VcpkgFindOrInstall.bat"
)

for %%i in ("!VCPKG_EXE!") do set "VCPKG_ROOT_DIR=%%~dpi"
set "VCPKG_ROOT=!VCPKG_ROOT_DIR!"
setx VCPKG_ROOT "!VCPKG_ROOT_DIR!"

call "%SCRIPT_PATH%\Vcpkg\VcpkgUpdate.bat"

call "%SCRIPT_PATH%\Project\CheckAndGenerateFiles.bat"

endlocal 
exit /b 0