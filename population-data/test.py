#!/usr/bin/env python3
with open("1970.txt", "r") as newfile:
    lines = list(newfile.readlines())
    lines = [x[:-1].strip() for x in lines]
    for x in range(0, len(lines) - 1):
        try:
            if lines[x+1].split()[0].isnumeric():
                print(("".join(word+" " for word in lines[x].split()))[:-1])
            else:
                print(("".join(word+" " for word in lines[x].split()))[:-1], end="")
        except IndexError:
            print(("".join(word+" " for word in lines[x].split()))[:-1])
    print(("".join(word+" " for word in lines[-1].split()))[:-1])

