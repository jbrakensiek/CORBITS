CORBITS
=======

CORBITS is the Computed Occurrence of Revovling Bodies for the Investigation of Transiting Systems by Joshua Brakensiek and Darin Ragozzine.

Introduction
------------

To start using CORBITS, clone the repository.

    git clone https://github.com/jbrakensiek/CORBITS.git

You can build the CORBITS library and usage examples by typing `make`.  To only build the CORBITS library, type `make lib`.

Examples
--------

There are currently three usage examples for CORBITS.

* kepler-11: Reproduces the data making the golden curve in Figure 4 of Lissauer, et. al., 2011.  See [here](http://arxiv.org/abs/1102.0291).
* period-dist: Produces a period-ratio distribution of the Kepler Candidates (KOIs) which is geometrically debiased.  It utilizes the most recent data from the NASA Exoplanet Archive.  Summary histograms using matplotlib can be made with `make period-hist`.
* solar-system: Calculates the transit probabilities of the Solar System from the perspective of a distant external observer.

To build an example, type `make name-of-example`.  To run it, type `make run-name-of-example`.

-------

If you find CORBITS useful, please cite (Brakensiek & Ragozzine, in prep.).
