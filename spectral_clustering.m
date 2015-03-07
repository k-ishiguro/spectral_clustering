function Z = spectral_clustering(X, K, fig_flag)
% Z = spectral_clustering(X, K, fig_flag)
%
% implementation of the spectral clustering with 
% Random walk normalized graph laplacian. 
% Recommended to use this spectral clsutering. 
%
% Reference: 
% von Luxburg, "A Tutorial on Spectral Clusterin", Statistics and Computing, 
% 17(4), 395-416, 2007. 
%
% inputs:
% X  - N by N symmetric obervations
% K  - number of clusters, or truncated singular values
% fig_flag - if 1, show the mid-status
%
% output:
% Z - N by K assignments
%
% Written by Katsuhiko ISHIGURO <k.ishiguro.jp@ieee.org>
% Last update: 23/02/15 (dd/mm/yy)
% This software is released under the 3-clause BSD license, as in license.txt. 
% Copyright (c) 2015, Katsuhiko Ishiguro
figid = 0;
EPS = 0.000001;

[N, N2] = size(X);
assert(N == N2);

%% compute the degree matrix D
D = diag( sum(X, 1) );

if(fig_flag)
    figid = figid + 1;
    figure(figid)
    
    imagesc(X);
    colormap(1-gray);
    xlabel('j')
    ylabel('i')
    axis ij
    title('input X')
    
    figid = figid + 1;
    figure(figid)
    
    imagesc(D);
    colormap(1-gray);
    xlabel('j')
    ylabel('i')
    axis ij
    title('Degree matrix D')
    colorbar
end

%% compute the random-walk normalized matrix L
D_safe = diag(D); % vectorized
D_coef = diag(EPS + 1.0 / D_safe);

L = D - X;
L = D_coef * L;

if(fig_flag)
    figid = figid + 1;
    figure(figid)
    
    imagesc(L);
    colormap(1-gray);
    xlabel('j')
    ylabel('i')
    axis ij
    title('Random-walk Normalized Laplacian matrix L')
end

%% solve the generalized eigen decomposition
[V, S] = eig(L, D);

% choose first K minimum abs. valued eigenvalues and their eigenvectors
abs_d = abs(diag(S));
[val, idx] = sort(abs_d, 'ascend');

Vk = V(:, idx(1:K));

if(fig_flag)
    % show the eigenvalues plot
    figid = figid + 1;
    figure(figid)
    plot(val(1:K)); 
    title(['first K minimum (abs.) eigenvalues'])
    
    % show the eigenvectors
    figid = figid + 1;
    figure(figid)
    
    for k=1:K
       subplot(K,1,k);
       plot(V(:, k));
       title(['eigenvector of ', num2str(k), '-th eigenvalue'])
    end

end

%% perform k-means clustering

[idx, C] = kmeans(Vk, K);

if(fig_flag)
    % show the assignment histogram
    figid = figid + 1;
    figure(figid)
    hist(idx, K)
    title(['histogram of assignments'])
    
    % show the 2-D plots by the top two assignments
    figid = figid + 1;
    figure(figid)
    Y = Vk(:, 1:2);
    title(['visualizing k-menas by top 2 eigenvectors'])
    
    ccc = colormap;
    hold on;
    for k=1:K
       k_idx = find(idx == k);
       scatter(Y(k_idx, 1), Y(k_idx, 2));
    end
    hold off
    
end

% return assignments 
Z = zeros(N, K);
for k=1:K
    k_idx = idx == k;
    Z(k_idx, k) = 1;
end

