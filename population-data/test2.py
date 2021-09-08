#!/usr/bin/env python3
with open("comp1970.txt", "r") as newfile:
    lines = list(newfile.readlines())
    lines = [x[:-1].strip() for x in lines]
    already_hit_ids = []
    for line in lines:
        line_id = line.split()[0]
        if line_id not in already_hit_ids:
            already_hit_ids.append(line_id)
            print(("".join(word+" " for word in line.split()[1:-4]))[:-1])
