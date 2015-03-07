function spectral_clustering_sortedAssignments(X, Z, K, save_name_prefix, SHOW_FIG, SAVE_FIG, figid, ccc)
% spectral_clustering_sortedAssignments(X, Z, K, save_name_prefix, SHOW_FIG, SAVE_FIG)
%
% print the assignments by spectral clustering. 
%
% X                - N by N, symmetric observations
% Z                - N by K, assignments for clusters by spectral clustering
% K                - number of clusters
% save_name_prefix - string, output prefix
% SHOW_FIG         - 1/0, if 1 show figures
% SAVE_FIG         - 1/0, if 1 save figures
% figid            - integer, figure id. 
% ccc              - #colors by 3, color array. 
%
% Written by Katsuhiko ISHIGURO <k.ishiguro.jp@ieee.org>
% Last update: 23/02/15 (dd/mm/yy)
% This software is released under the 3-clause BSD license, as in license.txt. 
% Copyright (c) 2015, Katsuhiko Ishiguro

%% sorted clustering on matrix

[N, N2] = size(X);
assert( N == N2 );

% sort the item index
sorted_item_idx = 1:N;
start_idx = 1;
start_idx_save = ones(1,K);
for k=1:K
    zk_idx = find( Z(:, k) == 1 ); 
    sorted_item_idx(start_idx:start_idx+length(zk_idx)-1) = zk_idx;
    start_idx = start_idx + length(zk_idx);
    start_idx_save(k+1) = start_idx;
end

% sort the observation
xx_sorted = X;
xx_sorted = xx_sorted(sorted_item_idx, :);
xx_sorted = xx_sorted(:, sorted_item_idx);

f = figure(figid);
set(f, 'visible', 'off');
imagesc(xx_sorted);
colormap(1 - gray);
axis ij;
hold on;
ylabel('out item i (sorted)');
xlabel('in item j (sorted)');
title('observations with partitions estimated via spectral clustering')

% lines to separate clusters
for k=1:K
    k_mod = mod(k,64) + 1;
    col = ccc(k_mod, :);
    %col = ccc(k, :);
    hline1 = line( [0.5 N+0.5], [start_idx_save(k)-0.5 start_idx_save(k)-0.5], 'LineWidth', 2, 'Color', col);
    hline2 = line( [start_idx_save(k)-0.5 start_idx_save(k)-0.5], [0.5 N+0.5], 'LineWidth', 2, 'Color', col);
end

if SHOW_FIG
    set(f, 'visible', 'on');
end

if SAVE_FIG
    eval(['figname = ''', save_name_prefix, '_Z'';']);
    eval(['figname_fig = ''', figname, '.fig'';']); saveas(gcf,figname_fig);
    eval(['figname_eps = ''', figname, '.eps'';']); saveas(gcf,figname_eps,'epsc');
    eval(['figname_png = ''', figname, '.png'';']); saveas(gcf,figname_png);        
end

