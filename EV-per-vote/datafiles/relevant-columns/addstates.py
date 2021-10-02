#!/usr/bin/env python3

import sys
symbs = [x.split()[0:2] for x in open('1960.dat').readlines()]
f = open(sys.argv[1]).readlines()
f_lines = [x.split(" ")[0] for x in f]
for x in symbs:
    if x[0] in f_lines:
        print(f[f_lines.index(x[0])], end="")
    else:
        print(x[0] + " " + x[1] + " 0 0 0 0")
