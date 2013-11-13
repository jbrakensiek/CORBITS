# produces histograms of various period ratio distributions
# requires matplotlib

import numpy as np
import matplotlib.pyplot as plt
import pylab as P

def parse_list(line):
    return [float(x) for x in line.split(" ")]

fig = plt.figure()

hist_name = ["adj", "snr", "all"];
hist_title = {"adj":"Geometrically Debiased MHS Distribution",\
            "snr":"SNR and Impact Parameter Cut MHS Distribution",\
            "all":"MHS Distribution"\
}
hist_color = {"adj":"green",\
            "snr":"blue",\
            "all":"red"\
}
data_dir = "data/"

mu = {"all":30.7, "snr":23.7, "adj":25.7};
sd = {"all":18.5, "snr":13.1, "adj":13.5};

for name in hist_name:
    # start of histogram
    ax = fig.add_subplot(111)
    fdata = open(data_dir + "mhs_" + name + '_hist_py.txt', 'r');
    
    # period ratios
    x = parse_list(fdata.readline());
    
    # weight of each period ratio
    w = parse_list(fdata.readline());
    
    # number of bins
    b = 50
    
    # plot histogram
    n, bins, patches = P.hist(x, b, range = (0, 100), weights = w, facecolor = hist_color[name], histtype='barstacked', stacked=True)
    ax.set_xlabel('Mutual Hill Sphere Distance')
    ax.set_ylabel('Frequency')
    ax.set_title(hist_title[name])

    P.ylim([0, .2])

    # plot best-fit distribution
    tot = 0
    for i in range (0, len (x) - 1):
        if x[i] <= 100:
            tot += w[i]
    y = list (map (lambda x: (1/(sd[name] * np.sqrt (2 * np.pi))) * \
        np.exp(-(x - mu[name])**2 / (2 * sd[name] ** 2)) * 2 * tot, bins))
    l = P.plot (bins, y, 'k--', linewidth=1.5)

    fdata.close()

    fig.savefig(data_dir + "mhs_" + name + "_hist.pdf", format="pdf")

    fig.clear()
# end of histogram
