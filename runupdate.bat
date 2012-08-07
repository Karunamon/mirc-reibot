@ECHO OFF
rem Poor man's timeout!
ping 127.0.0.1
git reset --hard origin/master >> updatelog.log 2>&1
call registration.bat
ping 127.0.0.1
del /F /Q registration.bat
start mirc