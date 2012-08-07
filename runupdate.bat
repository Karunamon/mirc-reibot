@ECHO OFF
write -c registration.bat ping 127.0.0.1
git reset --hard origin/master >> updatelog.log 2>&1
registration.bat
del /F /Q registration.bat
mirc
