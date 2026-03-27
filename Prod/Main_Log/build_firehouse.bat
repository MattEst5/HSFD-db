@echo off
setlocal

cd /d "C:\Dev\Projects\Firehouse\Prod\Main_Log"

echo Cleaning old build artifacts...
rmdir /s /q build 2>nul
rmdir /s /q dist 2>nul
del /q Firehouse.spec 2>nul

echo Building Firehouse.exe...
py -m PyInstaller --onefile --console --clean --noconfirm ^
  --name "Firehouse" ^
  --icon "Firehouse.ico" ^
  "loggerV5.py"

echo Copying .env into dist...
copy /y ".env" ".\dist\.env" >nul

echo.
echo DONE: dist\Firehouse.exe
echo (with dist\.env beside it)
echo.
pause