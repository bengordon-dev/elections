#!/usr/bin/env python3
import sys
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

dem = mpatches.Patch(color='blue', label='Democratic')
gop = mpatches.Patch(color='red', label='Republican')
others = mpatches.Patch(color='green', label="Third Parties")
dataset = sys.argv[1]
grid = np.genfromtxt(dataset, dtype="float64")[::-1][:-1]

plt.subplot(2, 2, 1)
plt.plot(grid[:,0], grid[:,2], color="red")
plt.plot(grid[:,0], grid[:,4], color="blue")
plt.plot(grid[:,0], grid[:,6], color="green")
plt.xlabel('Election Year')
plt.ylabel('Votes')
plt.legend(handles=[dem, gop, others])
plt.title(f'Presidential elections in {sys.argv[1][:-5].replace("_", " ")} County, {sys.argv[2]}')

plt.subplot(2, 2, 2)
plt.plot(grid[:,0], np.log(grid[:,2]+1), color="red")
plt.plot(grid[:,0], np.log(grid[:,4]+1), color="blue")
plt.plot(grid[:,0], np.log(grid[:,6]+1), color="green")
plt.xlabel('Election Year')
plt.ylabel('log(votes+1)')

plt.subplot(2, 2, 3)
plt.plot(grid[:,0], grid[:,1], color="red")
plt.plot(grid[:,0], grid[:,3], color="blue")
plt.plot(grid[:,0], grid[:,5], color="green")
plt.xlabel('Election Year')
plt.ylabel('Vote Percentages')

plt.subplot(2, 2, 4)
plt.plot(grid[:,0], grid[:,2]+grid[:,4]+grid[:,6])
plt.xlabel('Election Year')
plt.ylabel('Total Votes')

plt.gcf().set_size_inches(12, 8)
#plt.gcf().savefig(f'plots/{sys.argv[1]}.png', dpi=100)
plt.show()


