function test_weighted_median()

n = 35;
m = 16;
u = rand(n, m);
% w = ones(n, 1);
% uo = weighted_median(w, u);

half_size = 1;
mask = ones(size(u));
[indx_row, indx_col] = find(mask ==1);

pad_u  = padarray(u, half_size*[1 1], 'symmetric', 'both');        
[H, W] = size(pad_u);

[C, R] = meshgrid(-half_size:half_size, -half_size:half_size);
nindx = R + C * H;
cindx = indx_row + half_size  + (indx_col + half_size - 1)*H;
pad_indx = repmat(nindx(:), [1 length(indx_row)]) + ...
    repmat(cindx(:)', [(half_size*2+1)^2, 1]);

neighbors_u = pad_u(pad_indx);
weights = ones(size(neighbors_u));
uo = weighted_median(weights, neighbors_u);
indx = sub2ind([n m], indx_row, indx_col);
uo_weighted = zeros(size(u));
uo_weighted(indx) = uo;

uo_nonweighted = medfilt2(u, [2 * half_size + 1 2 * half_size + 1], 'symmetric');

if norm(uo_weighted - uo_nonweighted) > 1e-10
    error('wrong')
end
end