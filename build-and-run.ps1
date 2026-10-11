# PowerShell Script to Build and Run Online Complaint Management Portal
$ErrorActionPreference = "Stop"

Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host " Online Complaint Management Portal - Build and Deploy Script" -ForegroundColor Green
Write-Host "=====================================================================" -ForegroundColor Cyan

# 1. Environment & JDK 17 Configuration
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot"
$env:Path = "$env:JAVA_HOME\bin;$env:Path"

Write-Host "[1/4] Verifying JDK 17..." -ForegroundColor Yellow
& "$env:JAVA_HOME\bin\java.exe" -version

# 2. Load .env if present
if (Test-Path ".env") {
    Write-Host "[2/4] Reading environment configuration from .env..." -ForegroundColor Yellow
    Get-Content ".env" | ForEach-Object {
        $line = $_.Trim()
        if ($line -and -not $line.StartsWith("#") -and $line.Contains("=")) {
            $parts = $line.Split("=", 2)
            [System.Environment]::SetEnvironmentVariable($parts[0].Trim(), $parts[1].Trim(), "Process")
        }
    }
}

if (-not $env:MONGODB_URI) {
    Write-Host "[INFO] MONGODB_URI not found. Set it in .env or system environment." -ForegroundColor Gray
}

# 3. Maven Build & Package
Write-Host "[3/4] Compiling and packaging WAR with Maven..." -ForegroundColor Yellow
& mvn clean package

if (-not (Test-Path "target\complaint-portal.war")) {
    Write-Error "Build failed: target\complaint-portal.war was not created."
}

# 4. Deploy to Tomcat 10.1
$tomcatDir = "C:\Users\Dell\tomcat-10.1"
if (Test-Path "$tomcatDir\webapps") {
    Write-Host "[4/4] Deploying WAR to $tomcatDir\webapps..." -ForegroundColor Yellow
    Copy-Item "target\complaint-portal.war" "$tomcatDir\webapps\complaint-portal.war" -Force
    Write-Host "[SUCCESS] Artifact deployed successfully!" -ForegroundColor Green
    Write-Host "Portal URL: http://localhost:8080/complaint-portal/" -ForegroundColor Cyan
    Write-Host "Default Admin: admin@college.edu / Admin@1234" -ForegroundColor Cyan
    Write-Host "Starting Tomcat..." -ForegroundColor Green
    Start-Process "http://localhost:8080/complaint-portal/"
    & "$tomcatDir\bin\catalina.bat" run
} else {
    Write-Host "Tomcat directory not detected at $tomcatDir. You can deploy target\complaint-portal.war to your Tomcat installation." -ForegroundColor Yellow
}
