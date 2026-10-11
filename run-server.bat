@echo off
setlocal enabledelayedexpansion

echo =====================================================================
echo  Online Complaint Management Portal - Tomcat 10.1 Launcher
echo =====================================================================

:: 1. Set JDK 17
set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot"
set "PATH=%JAVA_HOME%\bin;%PATH%"

:: 2. Set Tomcat directory
set "CATALINA_HOME=C:\Users\Dell\tomcat-10.1"

:: 3. Clean up any previous process occupying port 8080
echo [INFO] Checking if port 8080 is already in use...
for /f "tokens=5" %%p in ('netstat -aon ^| findstr ":8080" ^| findstr "LISTENING"') do (
    echo [INFO] Freeing port 8080 (Terminating PID: %%p)...
    taskkill /F /PID %%p >nul 2>&1
)

:: 4. Verify JDK 17
java -version
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Java 17 was not found at %JAVA_HOME%.
    pause
    exit /b 1
)

:: 5. Copy WAR to webapps
if not exist "target\complaint-portal.war" (
    echo [INFO] Building WAR archive via Maven...
    call mvn clean package -DskipTests
)

echo [INFO] Deploying target\complaint-portal.war to Tomcat...
copy /Y "target\complaint-portal.war" "%CATALINA_HOME%\webapps\complaint-portal.war" >nul

echo =====================================================================
echo  TOMCAT SERVER STARTING...
echo  Portal URL:       http://localhost:8080/complaint-portal/
echo  Default Admin:    admin@college.edu / Admin@1234
echo =====================================================================
echo [NOTE] Keep this window open while using the application!
echo.

:: 6. Launch browser after a brief delay in parallel
start "" cmd /c "timeout /t 3 /nobreak >nul && start http://localhost:8080/complaint-portal/"

:: 7. Start Tomcat
cd /d "%CATALINA_HOME%"
call "%CATALINA_HOME%\bin\catalina.bat" run
