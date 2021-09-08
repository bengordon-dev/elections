#!/usr/bin/env python3
with open("super1970.txt", "r") as newfile:
    lines = list(newfile.readlines())
    lines = [x[:-1].strip() for x in lines]
    for line in lines:
        if "." not in line:
            print(line)
