@echo off
cd /d "D:\GAMES - PC\multiplayer\idlepimps\project pimp"
start http://localhost:8000/idlepimps.html
python -m http.server 8000
pause