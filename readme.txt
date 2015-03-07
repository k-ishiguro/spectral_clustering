This software is released under the 3-clause BSD license, as in license.txt. 

Copyright (c) 2015, Katsuhiko Ishiguro


An naive Matlab implementations of Spectral Clustering for non-directional relational data. 

Please first try sepctral_clsterinrg_rum.m. 

###
# Main methods
###
spectral_clustering.m       - the main and the recommended algorithm by Shi and Malik (2001). 
                              Based on the random-walk normalized Graph Laplacian. 
spectral_clustering_naive.m - a naive algorithm. 
                              Based on the unnormalized Graph Laplacian. 
spectral_clustering_sym.m   - a normalized Graph Laplacian algorithm by Ng et al. (2000). 
                              Based on the symmetric normalized Graph Laplacian. 
###
# Data
###
I assume the input data is a formatted text data. 
The format is a BoW (Bag-of-Words) format of the UCI Machine Learning Repository (UCI-ML). 

Enjoy!!

Katsuhiko Ishiguro


