function [index1, index2,count] = getIndex(data)
dbg = 0;
if dbg
%     load data/data_tmp_getIndex.mat;
   pt = pcread('data/longdress/Ply/longdress_vox10_1051.ply');
   data = pt.Location;
end
% dataq = sortrows(data, 3);         % 1. sort depth value
%(ix,iy,iz)=unque(x,'rows','first'), x(iy,:)=ix, ix(iz,:)=x

[~, ia1, ic1] = unique(data,'rows','first','legacy');    %  2. pick up min/max depth with equal xy
[~, ia2, ~] = unique(data,'rows','last','legacy'); 
count = hist(ic1,unique(ic1));

index1 = ia1;
index2 = ia2; % index2 = setdiff(ia2,intersect(ia1,ia2));

%%
% % 3. decide the correct projective plane for points
% index = union(ia1, ia2);             
% thres_depth = mean(data(index,3));   % 3.1. set proper criteria for points with unique (x,y)
% i = intersect(ia1, ia2);        
% i11 = find(data(i,3) <= thres_depth);
% i21 = find(data(i,3) > thres_depth);
% 
% i12 = setdiff(ia1,i);                % 3.2. correct the wrong projection induced by pca
% i22 = setdiff(ia2,i);
% 
% data1 = data(i12,:);   data2 = data(i22,:);
% [~, ib1, ib2] = intersect(data(i12,1:2), data(i22,1:2),'rows');
% data1 = data1(ib1,:);   data2 = data2(ib2,:);
% depth1 = data1(:,3);  depth2 = data2(:,3);
% diff = abs(depth2 - depth1);
% tmp_index = (diff < 2);            % can not correct all
% tmp_index1 = (depth1(tmp_index) > thres_depth);
% tmp_index2 = (depth2(tmp_index) <= thres_depth);
% if any(tmp_index2)
%     b = i22(ib2);
%     b1 = b(tmp_index);
%     b2 = b1(tmp_index2);
%     i22 = setdiff(i22,b2);         % remove 
% end
% if any(tmp_index1)
%     a = i12(ib1);
%     a1 = a(tmp_index);
%     a2 = a1(tmp_index1);
%     i12 = setdiff(i12,a2);
% end
% 
% index1 = union(i11,i12);
% index2 = union(i21,i22);
end

