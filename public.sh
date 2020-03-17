#!/usr/bin/env bash

yarn build
cd public || cd .
git add .
git commit -m "Update - $(date +D:%d%m%Y-H:%H%M%S)"
git push origin master
cd ..

