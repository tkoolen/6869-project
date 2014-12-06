function [mvx mvy] = bma(im1, im2, block_size, search_size, medfilt_size)
noise_mask = 0.0000001*rand(size(im1));
im1 = im1;
im2 = im2;
mvx = zeros(size(im1));
mvy = zeros(size(im1));
%search_size = 3*block_size;
g_kern = fspecial('gaussian',[block_size block_size],block_size/2);
[nrows ncols] = size(im1);
for rr=search_size/2+1:block_size:nrows-1*block_size-search_size/2
    for cc=search_size/2+1:block_size:ncols-1*block_size-search_size/2
        patch = im1(rr:rr+block_size-1, cc:cc+block_size-1);
        %patch = patch+0.000001*rand(size(patch));
        search_win = im2(max(1,rr-search_size/2):min(nrows,rr+search_size/2),...
            max(1,cc-search_size/2):min(ncols,cc+search_size/2));
        
        if std(patch(:)) ~= 0
        [mvx_tmp mvy_tmp] = find_bmv(patch, search_win);
        mvx_tmp = mvx_tmp-search_size/2-1; 
        mvy_tmp = mvy_tmp-search_size/2-1;
        %mvx(rr, cc) = mvx_tmp;
        %mvy(rr, cc) = mvy_tmp;
        mvx(rr:rr+block_size-1, cc:cc+block_size-1) = mvx_tmp;
        mvy(rr:rr+block_size-1, cc:cc+block_size-1) = mvy_tmp;  
        end
                
    end
end
mvx_new = zeros(size(mvx));
mvy_new = zeros(size(mvy));

mvx = mvx(search_size/2+1:end-search_size/2, search_size/2+1:end-search_size/2);
mvy = mvy(search_size/2+1:end-search_size/2, search_size/2+1:end-search_size/2);
% mvx = mvx(search_size/2+1:block_size:end, search_size/2+1:block_size:end);
% mvy = mvy(search_size/2+1:block_size:end, search_size/2+1:block_size:end);
% %mvy(mvy==0, :) = [];
% mvx = imresize(mvx, size(im1)-[search_size search_size], 'bicubic');
% mvy = imresize(mvy, size(im1)-[search_size search_size], 'bicubic');
% [Y X] = find(mvx == 0);
% [Y2 X2] = find(mvx~=0);
% 
% for ii = 1:length(Y)
% for jj = 1:length(X)
%     mvx_tmp = interp2(mvx, Y(jj), X(ii));
%     if ~isnan(mvx_tmp)
%         mvx(Y(ii),X(jj)) = mvx_tmp;
%     end
%     mvy_tmp = interp2(mvy, Y(jj), Y(ii));
%     if ~isnan(mvy_tmp)
%         mvy(Y(ii),X(jj)) = mvy_tmp;
%     end
% 
% end
% end

%g_kern = fspecial('gaussian',[block_size/2 block_size/2],block_size);
%tic
mvx = medfilt2(mvx, [medfilt_size medfilt_size], 'symmetric');
mvy = medfilt2(mvy, [medfilt_size medfilt_size], 'symmetric');
mvx_new(search_size/2+1:end-search_size/2, search_size/2+1:end-search_size/2) = mvx;
mvx = mvx_new;
mvy_new(search_size/2+1:end-search_size/2, search_size/2+1:end-search_size/2) = mvy;
mvy = mvy_new;

%toc
%mvx = imfill(mvx, 'holes');
%mvy = imfill(mvy, 'holes');
end