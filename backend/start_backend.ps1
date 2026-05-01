Write-Host "Starting RGA Agricultural Backend..." -ForegroundColor Cyan

# 1. Install Dependencies
Write-Host "Checking Dependencies..." -ForegroundColor Yellow
pip install fastapi uvicorn sqlalchemy psycopg2-binary pydantic[email] pydantic-settings python-jose[cryptography] passlib[bcrypt] python-multipart --quiet

# 2. Seed Password
Write-Host "Setting up Seed Data..." -ForegroundColor Green
python seed_passwords.py

# 3. IP Info
$ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -like "*Wi-Fi*" -or $_.InterfaceAlias -like "*Ethernet*" }).IPAddress[0]
Write-Host "Your Backend IP: http://$($ip):8000/api/v1" -ForegroundColor Cyan

# 4. Start Server
Write-Host "Starting Server on 0.0.0.0:8000..." -ForegroundColor Green
python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
