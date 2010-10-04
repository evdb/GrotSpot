#!/bin/bash

rsync -rlpvzt \
  --delete \
  --exclude .DS_Store \
  --exclude=.git \
  . \
  www-data@yournextmp.com:/var/www/grotspot 