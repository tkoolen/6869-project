function driverfn_BM_HS()

run_control = false;

addpath('..');
addpath('../utils');
addpath('flow-code-matlab/');
iptsetpref('ImshowBorder', 'tight')

imageset = 'Grove2';
img1 = imread(['training/' imageset '/frame10.png']); img1 = im2double(img1); %img1 = mean(img1, 3);
img2 = imread(['training/' imageset '/frame11.png']); img2 = im2double(img2); %img2 = mean(img2, 3);
GT = readFlowFile(['other-gt-flow/' imageset '/flow10.flo']);

search_size = 20;

% ground truth
GT = GT(search_size/2+1:end-search_size/2, search_size/2+1:end-search_size/2, :);
u_GT = GT(:,:,1);
v_GT = GT(:,:,2);
% figure,imshow(flowToColor(GT))

% block matching
tic
uvo = estimate_flow_using_BMA(img1, img2, 'classic++');
toc
uvo = uvo(search_size/2+1:end-search_size/2, search_size/2+1:end-search_size/2,:);
figure,imshow(flowToColor(uvo))
[aae, stdae, aepe] = flowAngErr(u_GT, v_GT, uvo(:,:,1), uvo(:,:,2), 0);
fprintf('\nBMA AAE %3.3f average EPE %3.3f \n', aae, aepe);

% control
if run_control
    tic
    uv = estimate_flow_interface(img1, img2, 'classic++');
    toc
    uv = uv(search_size/2+1:end-search_size/2, search_size/2+1:end-search_size/2,:);
    figure,imshow(flowToColor(uv))
    [aae, stdae, aepe] = flowAngErr(u_GT, v_GT, uv(:,:,1), uv(:,:,2), 0);
    fprintf('\nCONTROL AAE %3.3f average EPE %3.3f \n', aae, aepe);
end

end
