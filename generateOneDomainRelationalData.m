% This software is released under the 3-clause BSD license, as in license.txt. 
% Copyright (c) 2015, Katsuhiko Ishiguro
%
% Written by Katsuhiko ISHIGURO <k.ishiguro.jp@ieee.org>
% Last update: 23/02/15 (dd/mm/yy)
clear all; close all; c = clock; rand(sum(c(1:6)));
figid = 0;

% initial number of clusters
KK = 4

% noisiness of simulated data
noise = 0.01

save_name_prefix = 'test_K4'

%% generate an observation

% generate the clean assignment
Ns = [30, 30, 20, 50] % the true K = 4

% clsuter assignments
N = sum(Ns);
trueK = length(Ns);
trueZ = zeros( N, 1 );
start_idx = 0;
end_idx = 0;
for k=1:trueK
    start_idx = end_idx + 1;
    end_idx = end_idx + Ns(k);
    trueZ(start_idx:end_idx) = k;
end

% connectivity among clusters
affinity = 0.3 * rand(trueK);
for k=1:trueK
    affinity(k,k) = 0.5 + 0.4 * rand(1);
end

% clean relationas
X_clean = rand(N);
for i=1:N
    z_i = trueZ(i);
    for j=i:N
        z_j = trueZ(j);
        
        if X_clean(i,j) < affinity(z_i, z_j)
            X_clean(i,j) = 1;
        else
            X_clean(i,j) = 0;
        end

        X_clean(j,i) = X_clean(i,j);        
    end % end j-for
end % end j-for
figid = figid + 1;
figure(figid)
imagesc(X_clean);
colormap(1-gray);
xlabel('j')
ylabel('i')
title('clean relationship')

% noisy relationas
X = X_clean;
noises = rand(N);
[i_idx, j_idx] = find(noises < noise);
disp(['flipping ', num2str(length(i_idx)), ' entries'])

for n=1:length(i_idx)
    i = i_idx(n);
    j = j_idx(n);
    
    X(i,j) = 1 - X(i,j);
    X(j,i) = X(i,j);
end

figid = figid + 1;
figure(figid)
imagesc(X);
colormap(1-gray);
xlabel('j')
ylabel('i')
title('observation = noisy relationship')

% Write in UCI-BoW
fid = fopen([save_name_prefix, '.dat'], 'w');
fprintf(fid, [num2str(N), '\n']);
fprintf(fid, [num2str(N), '\n']);
NNZ = sum(sum(X));
fprintf(fid, [num2str(NNZ), '\n']);
for i=1:N
    for j=1:N
        if(X(i,j) > 0)
            fprintf(fid, [num2str(i), ' ', num2str(j), ' ', num2str(X(i,j)), '\n']);
        end
    end
end
fclose(fid);
