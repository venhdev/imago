@echo off

REM Set default package name
SET PACKAGE=codekit

REM Allow override via first argument
IF NOT "%~1"=="" SET PACKAGE=%~1%

REM Define source and destination
SET SOURCE=..\%PACKAGE%\lib
SET DEST=lib\src\vendor\%PACKAGE%

echo Vendoring: %PACKAGE%
echo Deleting old vendor at %DEST%...
rmdir /s /q %DEST%

echo Creating vendor folder: %DEST%
mkdir %DEST%

echo Copying files from %SOURCE% ...
xcopy /E /I /Y %SOURCE%\* %DEST%\

echo Done. Check:
echo - import paths (use relative)
echo - LICENSE file (add if missing)
