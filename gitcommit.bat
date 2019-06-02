@echo off
set gitwarehouse=https://github.com/myktw/Shadowsock.git
git add .
git commit -m "commit"
git remote add origin %gitwarehouse%
git push -u origin master
