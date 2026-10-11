@echo off
echo Stopping any running Tomcat instances on port 8080...
for /f "tokens=5" %%p in ('netstat -aon ^| findstr ":8080" ^| findstr "LISTENING"') do (
    taskkill /F /PID %%p >nul 2>&1
    echo Terminated process with PID %%p on port 8080.
)
echo Server stopped.
pause
