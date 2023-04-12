#!/bin/bash

mkdir -p play
docker build -t misfortune .
docker run -v `pwd`/play:/bins misfortune bash -c 'cp misfortune /bins; cp /lib/x86_64-linux-gnu/libc.so.6 /bins'
sudo chown $LOGNAME:$LOGNAME ./play/*
chmod u+rwx ./play/*

echo '[+] binary and libc are now in ./play folder :)'