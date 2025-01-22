@echo off
setlocal enabledelayedexpansion

:: Change to the directory containing the batch file
pushd "%~dp0"

:: Set the output file
set "output_file=directory_structure.txt"

:: Clear the output file if it exists
if exist "%output_file%" del "%output_file%"

:: Write header to file
echo Directory Structure for: %CD% > "%output_file%"
echo Created on: %date% at %time% >> "%output_file%"
echo. >> "%output_file%"

:: Function to list directory contents
:listDir
setlocal
set "currentPath=%~1"
set "prefix=%~2"

:: List files in current directory (including hidden and system files)
echo %prefix%Files: >> "%output_file%"
for %%F in ("%currentPath%*" "%currentPath%.*") do (
    if not "%%~aF:~0,1"=="d" (
        if not "%%~nxF"=="." if not "%%~nxF"==".." (
            echo %prefix%    %%~nxF >> "%output_file%"
        )
    )
)

:: List and process all subdirectories (including those starting with underscore)
for /f "delims=" %%D in ('dir /ad /b "%currentPath%*" "%currentPath%.*"') do (
    if not "%%D"=="." if not "%%D"==".." (
        echo. >> "%output_file%"
        echo %prefix%[Directory: %%D] >> "%output_file%"
        call :listDir "%currentPath%%%D\" "%prefix%    "
    )
)

endlocal
exit /b

:: Start the recursive listing from current directory
call :listDir ".\" ""

popd

echo.
echo Directory structure has been saved to: %output_file%
echo.

endlocal