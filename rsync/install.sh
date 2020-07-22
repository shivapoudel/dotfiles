#!/bin/bash

cd /tmp/
curl -SO# http://repo.msys2.org/msys/x86_64/rsync-3.1.3-1-x86_64.pkg.tar.xz
tar -xvf rsync-3.1.3-1-x86_64.pkg.tar.xz
mv usr/bin/rsync.exe /usr/bin/
