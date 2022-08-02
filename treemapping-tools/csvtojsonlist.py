#!/usr/bin/env python3
import sys, os

os.chdir("./" + sys.argv[1])
state = sys.argv[2]
first_year = int(sys.argv[3])
last_year = int(sys.argv[4])
camelState = state[0].lower() + state[1:].replace("_", "")
print("export const " + camelState + " = [")
for year in range(first_year, last_year + 4, 4):
    f = open(state + str(year) + ".csv", "r")
    firstline = f.readline().replace("\n", "").split(",")
    numcols = [i for i, title in enumerate(firstline) if title.endswith("_NUM") and not title.startswith("Margin") and not title.startswith("Total") ]
    pctcols = [i for i, title in enumerate(firstline) if title.endswith("_PCT") and not title.startswith("Margin") ]
    
    mrgnumindex = -1
    mrgpctindex = -1
    if "Margin_NUM" in firstline: 
        mrgnumindex = firstline.index("Margin_NUM")
    elif "MRG_NUM" in firstline:
        mrgnumindex = firstline.index("MRG_NUM")
    if "Margin_PCT" in firstline:
        mrgpctindex = firstline.index("Margin_PCT")
    elif "MRG_PCT" in firstline:
        mrgpctindex = firstline.index("MRG_PCT")

    stateyear = sys.argv[1].split(".")[0].replace("_", "")
    stateyear = stateyear[0].lower() + stateyear[1:]

    print("{year: " + str(year) + ", countyData: [") 
    for x in f:
        l = x.replace("\n", "").replace("N/A", "0").split(",")
        l = [l[0]] + [float(x) if "." in x else int(x) for x in l[1:]]
        parties = []
        for i in range(0, len(pctcols)):
            parties.append([firstline[pctcols[i]].split("_")[0], l[pctcols[i]], l[numcols[i]]])
        parties.sort(key=lambda x: x[1], reverse=True)
        total = 0
        if ("Total" in firstline):
            total = l[firstline.index("Total")]
        else: 
            total = sum([l[i] for i in numcols])

        pctindex = 1 + ((pctcols[0] - numcols[0] + 1) // 2)
        numindex = 1 + ((numcols[0] - pctcols[0] + 1) // 2)

        margin_pct = abs(l[mrgpctindex]) if mrgpctindex >= 0 else abs(parties[0][pctindex] - parties[1][pctindex])
        margin_num = abs(l[mrgnumindex]) if mrgnumindex >= 0 else abs(parties[0][numindex] - parties[1][numindex])

        print("  {label: " + '"' + str(l[0]) + '"' + ', party: "' + str(parties[0][0]) + '", marginVotes: ' + str(abs(margin_num))  
            + ", marginPct: " + str(abs(margin_pct)) + ", totalVotes: " + str(total) + "},")
    print("]},")
print("]")