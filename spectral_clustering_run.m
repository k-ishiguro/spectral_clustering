% Implemenation of the spectral clustering algorithms. 
%
% Reference: 
% von Luxburg, "A Tutorial on Spectral Clusterin", Statistics and Computing, 
% 17(4), 395-416, 2007.  
%
% Input data is assumed in the format of UCI-ML bag-of-words:
% <top of the file>
% NN1 - number of (input) objects
% NN2 - number of (output) objects, NN1 == NN2 is required. 
% NNZ - number of nonzero lines below = number of non-zero observations
% in-itemID out-timeID count - count must be non-negative
% in-itemID out-timeID count
% ...
%
% Hyper paramter:
% K - number of clusters for k-means, and number of truncated singular
% values. K << N. 
%
% Written by Katsuhiko ISHIGURO <k.ishiguro.jp@ieee.org>
% Last update: 23/02/15 (dd/mm/yy)
% This software is released under the 3-clause BSD license, as in license.txt. 
% Copyright (c) 2015, Katsuhiko Ishiguro

clear all; close all; c = clock; rand(sum(c(1:6)));
seed = 100;
rng(seed);
figid = 0;
DEBUG = 1;

%% input arguments you need to specify

% if you want to see figures, set 1
SHOW_FIG = 1

% if you wan to save figures, set 1
SAVE_FIG = 0

% number of clusters
K = 4

% input UCI-ML-BoW format data
file_name = 'test_K4.dat'

% output prefix, if you want to save the result figures
save_name_prefix = 'spectral_clustering_test'

save_name_prefix = [save_name_prefix, '_K', num2str(K)]

%% input the data

% observation: UCI-ML BoW format only
[X NN oNN] = readUCIBoW(file_name);
assert( NN == oNN );
% 
% % random masks for test-data evaluations.
% ratio_flips = 0.01;
% rand_mat = rand(NN, NN);
% [test_i_index test_j_index] = find(rand_mat < ratio_flips);
% test_index = [test_i_index test_j_index];

fprintf('loading data done\n');

%% Solve by three spectral clustering algorithms. 

% not recommended: 
% perform spectral clustering with unnormalized Laplacian
Z_unnormalized = spectral_clustering_naive(X, K, SHOW_FIG);
fprintf('finished unnormalized S.C. \n');
%fprintf('waiting\n'); pause

% not recommended:
% perform spectral clustering with symmetric normalized Laplacian
Z_sym = spectral_clustering_sym(X, K, SHOW_FIG);
fprintf('finished symmetric normalized S.C. \n');
%fprintf('waiting\n'); pause

% recommended: 
% perform spectral clustering with random-walk normalized Laplacian
Z = spectral_clustering(X, K, SHOW_FIG);
fprintf('finished random-walk normalized S.C. \n');
%fprintf('waiting\n'); pause

%% Visualize the results
ccc = colormap(jet);
ccc = ccc(randperm(size(ccc,1)),:);
%    close all;

save_name_prefix_un = [save_name_prefix, '_Unnormalized'];
spectral_clustering_sortedAssignments(X, Z_unnormalized, K, ...
    save_name_prefix_un, SHOW_FIG, SAVE_FIG, 11, ccc);

save_name_prefix_sym = [save_name_prefix, '_Symmetric'];
spectral_clustering_sortedAssignments(X, Z_sym, K, ...
    save_name_prefix_sym, SHOW_FIG, SAVE_FIG, 12, ccc);

save_name_prefix_rw = [save_name_prefix, '_Randomwalk'];
spectral_clustering_sortedAssignments(X, Z, K, ...
    save_name_prefix_rw, SHOW_FIG, SAVE_FIG, 13, ccc);

% that's all!