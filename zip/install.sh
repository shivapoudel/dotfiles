#!/bin/bash

cd /tmp/
curl -SO# http://repo.msys2.org/msys/x86_64/zip-3.0-3-x86_64.pkg.tar.xz
tar -xvf zip-3.0-3-x86_64.pkg.tar.xz
mv usr/bin/zip.exe /usr/bin/
