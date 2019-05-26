@echo off
set gitwarehouse=http://myktw.cn:3000/ktw/Shadowsock-R.git
git add .
git commit -m "commit"
git remote add origin %gitwarehouse%
git push -u origin master