function [mvx mvy] = find_bmv(patch, img)
    corr_img = normxcorr2(patch, img);
    [mvy mvx] = find(abs(corr_img)==max(max(abs(corr_img))));
    if sum(sum(abs(corr_img)==max(max(abs(corr_img))))) > 1
        mvy = 0; mean(mvy);
        mvx = 0; mean(mvx);
    end
    corr_offset = [mvx-size(patch,2) mvy-size(patch,1)];
    
    mvx = corr_offset(1)+1;
    mvy = corr_offset(2)+1;
end