# produces histograms of various period ratio distributions
# requires matplotlib

import numpy as np
import matplotlib.pyplot as plt
import pylab as P

def parse_list(line):
    return [float(x) for x in line.split(" ")]

fig = plt.figure()

# key resonances
res = [[1.5, '3:2'], [2, '2:1'], [2.5, '5:2'], [3, '3:1'], [7/3.0, '7:3'], [8/3.0, '8:3'], [5/3.0, '5:3'], [4/3.0, '4:3']]

hist_name=["adj", "snr", "all"];
hist_title={"adj":"Geometrically Debiased Resonance Distribution",\
            "snr":"SNR and Impact Parameter Cut Resonance Distribution",\
            "all":"Resonance Distribution"\
}
hist_color={"adj":"green",\
            "snr":"blue",\
            "all":"red"\
}
data_dir = "data/"

mu={"all":0.76, "snr":0.74, "adj":0.81}
sd={"all":0.33, "snr":0.31, "adj":0.32}

for name in hist_name:
    # start of histogram
    ax = fig.add_subplot(111)
    fdata = open(data_dir + "per_" + name + '_hist_py.txt', 'r');
    
    # period ratios
    x = parse_list(fdata.readline());
    
    # weight of each period ratio
    w = parse_list(fdata.readline());
    
    # number of bins
    b = 60
    
    # plot histogram
    n, bins, patches = P.hist(x, b, range = (1, 4), weights = w, facecolor = hist_color[name], histtype='barstacked', stacked=True)
    ax.set_xlabel('Period Ratio')
    ax.set_ylabel('Frequency')
    ax.set_title(hist_title[name])
    
    # plot resonance values
    for p in res:
        ax.axvline (x = p[0], ls = 'dashed', color = 'black')
        ax.text (p[0], .0485, p[1], ha='center', color = hist_color[name])

    P.ylim([0, .05])

    # plot best-fit distribution
    tot = 0
    for i in range (0, len (x) - 1):
        if x[i] <= 4:
            tot += w[i]

    y = list (map (lambda x: (1/(x * sd[name] * np.sqrt (2 * np.pi))) * np.exp(-(np.log(x) - mu[name])**2 / (2 * sd[name] ** 2))/20 * tot, bins))
    l = P.plot (bins, y, 'k--', linewidth=1.5)

    fdata.close()

    fig.savefig(data_dir + "per_" + name + "_hist.pdf", format="pdf")

    fig.clear()
# end of histogram
