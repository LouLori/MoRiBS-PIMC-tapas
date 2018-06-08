#!/usr/bin/python
#!/usr/bin/env python
import numpy as np
from numpy import *
import matplotlib
matplotlib.use('pdf')
import matplotlib.pyplot as plt
from itertools import cycle
import itertools
from scipy.optimize import curve_fit
from subprocess import call
from matplotlib.backends.backend_pdf import PdfPages
from matplotlib.ticker import ScalarFormatter
import support
import os
 
import matplotlib.mlab as mlab

fig = plt.figure()

num_bins = 50
x = loadtxt("output_instant.dof", unpack=True, usecols=[1])
#y = loadtxt("data-cost-16-norotskip-data", unpack=True, usecols=[0])
#y = y*10
print(len(x))
#print(len(y))
#x, y = loadtxt("pigs_instant.dof", unpack=True, usecols=[0, 1])
#z=0.5*(x+y)
#x1 = np.array(x)
#y1 = np.array(y)
#z1 = np.concatenate((x1,y1),axis=0)
plt.hist(x, num_bins, normed=1, facecolor='green', alpha=0.5, label = "TS")
#plt.hist(y, num_bins, normed=1, facecolor='blue', alpha=0.5, label = "MS")
#plt.hist(z1, num_bins, normed=1, facecolor='black', alpha=0.5)
plt.xlabel('bins')
plt.ylabel('Probability')

# Tweak spacing to prevent clipping of ylabel
plt.subplots_adjust(left=0.15)

outfile = "hist-test.pdf"
plt.savefig(outfile, dpi = 200, format = 'pdf')
#call(["okular", outfile])
call(["open", outfile])
