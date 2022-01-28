#!/usr/bin/env python3
import sys, os


f = open(sys.argv[1], "r")
firstline = f.readline().replace("\n", "").split(",")

#firstline.append("Total")
numcols = [i for i, title in enumerate(firstline) if title.endswith("_NUM") and not title.startswith("Margin") ]
pctcols = [i for i, title in enumerate(firstline) if title.endswith("_PCT") and not title.startswith("Margin") ]
mrgnumindex = firstline.index("Margin_NUM")
mrgpctindex = firstline.index("Margin_PCT")
print(firstline)

stateyear = sys.argv[1].split(".")[0].replace("_", "")
stateyear = stateyear[0].lower() + stateyear[1:]

print("export const " + stateyear + " = [")
for x in f:
    l = x.replace("\n", "").split(",")
    l = [l[0]] + [float(x) if "." in x else int(x) for x in l[1:]]
    parties = []
    for i in range(0, len(pctcols)):
        parties.append([firstline[pctcols[i]].split("_")[0], l[pctcols[i]], l[numcols[i]]])
    parties.sort(key=lambda x: x[1], reverse=True)
    total = sum([l[i] for i in numcols])

    print("  {label: " + '"' + str(l[0]) + '"' + ", parties: " + str(parties) + ", marginVotes: " + str(abs(l[mrgnumindex]))  
        + ", marginPct: " + str(abs(l[mrgpctindex])) + ", totalVotes: " + str(total) + "},")
print("]")