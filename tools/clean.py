#!/usr/local/bin/python

# Strips extra stuff at the end of each aya, present in quran-data
# repository of Khaled Hosny

# Sample run command
# for ((s=1;s<=114;s++)); do
#   ss=$s;
#   if (( $s < 100 )); then
#     ss=0$ss;
#   fi;
#   if (( $s < 10 )); then
#     ss=0$ss;
#   fi;
#   echo $s $ss;
#   /path/to/clean.py < /path/to/repository/quran/$ss.txt > raw-$s.txt;
# done

import sys

# SPC, LF, CR, arabic digits 0-9
ignore_chars = [ 0x20, 10, 13, 0x6DD, 0x660, 0x661, 0x662, 0x663,
                 0x664, 0x665, 0x666, 0x667, 0x668, 0x669 ]

for line in sys.stdin:
    line = line.decode("utf-8")
    i = len(line) - 1
    while i >= 0 and ord(line[i]) in ignore_chars:
        i = i-1
    line = line[:i+1]
    print line.encode('utf-8')
