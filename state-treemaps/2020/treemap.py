#!/usr/bin/env python3
import matplotlib.pyplot as plt
import squarify
import numpy as np
import sys
import os
grid = np.genfromtxt(sys.argv[1], dtype="float64")
counties = os.popen("awk '{print $1}' " + sys.argv[1]).read().split('\n')[1:-1]
nums = grid[1:,1:] #removes labels

colors = []
cols = ["#000033", "#010144", "#000051", "#002B84", "#0645B4", "#1666CB", "#4389E3", "#86B6F2", "#ABD3FF", "#C5E1FF", "#FFD4D4", "#FFB2B2", "#FF7F7F", "#FF4C4C", "#FF0000", "#B20000", "#7F0000", "#660000", "#4C0000", "#330000"]
for mrg in nums[:,1]:
    colors.append(cols[int((mrg+1)*10)])

squarify.plot(sizes=nums[:,0], label=counties, color=colors, text_kwargs={"color":"white"})
plt.title('2020 US Presidential Election in ' + sys.argv[1])
plt.gcf().set_size_inches(18, 18)
plt.gcf().savefig(f'plots/{sys.argv[1]}.png', dpi=100)
