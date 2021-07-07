
 function [ image, map, bb, data_remains, index, occupancy ] = getProjection_image( pt )
% Get the projection from 3D point cloud to 2D images and depth maps
% trial of 6 view projection, occluded_v2 with multi-occupancy
% 2017/12/25 

xyz = round(pt.Location);  rgb = single(pt.Color);
%% project to 6-faces of the bounding box in the principal component space
% Regularization
% if ii==1
%     xyz=inter(pt,1,700);
% end
% if ii==4
%     xyz=inter(pt,1,750);
% end
% if ii==7
%     xyz=inter(pt,1,700);
% end
% if ii==8
%     xyz=inter(pt,1,600);
% end
% if ii==9
%     xyz=inter(pt,1,780);
% end
[value_min,~]=min(xyz,[],1);
if value_min(1,1)<0
xyz(:,1)=xyz(:,1)-value_min(1,1);
end;
if value_min(1,2)<0
xyz(:,2)=xyz(:,2)-value_min(1,2);
end;
if value_min(1,3)<0
xyz(:,3)=xyz(:,3)-value_min(1,3);
end;
dataq = (xyz + 1);

data_remains = 0;
% xoy projection
dataq = [ dataq, rgb];                    % Preparation: xyz & color
[data_xoy, indexq_xoy] = sortrows(dataq, 3);                
[index1, index2, count_xoy] = getIndex(data_xoy(:,1:2));

index1 = indexq_xoy(index1);    index2 = indexq_xoy(index2); 
index_xoy = union(index1, index2);
if max(count_xoy) <= 2
    n = 2;   
else    
    [data_yoz, indexq_yoz] = sortrows(dataq, 1);  
    [index3, index4, count_yoz] = getIndex(data_yoz(:,[2,3]));
    
    index3 = indexq_yoz(index3);    index4 = indexq_yoz(index4);
    index_yoz = union(index3, index4);
    
    if max(count_yoz) <= 2
        n = 4;
    else              
        [data_zox, indexq_zox] = sortrows(dataq,2); 
        [index5, index6, count_zox] = getIndex(data_zox(:,[3,1]));
        
        index5 = indexq_zox(index5);    index6 = indexq_zox(index6);
        index_zox = union(index5, index6);
        
        if max(count_zox) <= 2
            n = 6;
        else
            n = 6;
            data_remains = dataq(setdiff(1:1:length(dataq), unique([index_xoy;index_yoz;index_zox])),:);
        end
    end    
end
n = 6;
% [index1, index2, count_xoy] = getIndex(data_xoy(:,1:2));
% index_xoy = union(index1, index2);
% 
% data_yoz = sortrows(dataq, 1);  
% [index3, index4, count_yoz] = getIndex(data_yoz(:,[2,3]));
% index_yoz = union(index3, index4);
% 
% data_zox = sortrows(dataq,2); 
% [index5, index6, count_zox] = getIndex(data_zox(:,[3,1]));
% index_zox = union(index5, index6);

datap1 = dataq;
datap2 = dataq(:,[2,3,1,4:6]);
datap3 = dataq(:,[3,1,2,4:6]);

% Decide number of the project plane
resolution = 1280 ;
bb = cell(n,1);  index = cell(n,1);
map = cell(n,1);  image = cell(n,1);   occupancy = cell(n,1);
Y = cell(n,1);      U = cell(n,1);    V = cell(n,1);
%% Generation of depth maps & color images
%box=zeros(6,4);
for i = 1:n
    datap = eval(['datap',num2str(ceil(i/2))]);
    index{i} = eval(['index',num2str(i)]);
    bb{i} = [min(datap(:,1:2)), max(datap(:,1:2))];

    map{i} = zeros(resolution);
    map{i}(sub2ind(size(map{i}),datap(index{i},2),datap(index{i},1))) = datap(index{i},3);  % for quantization q2

    Y{i} = zeros(resolution); U{i} = zeros(resolution); V{i} = zeros(resolution);  
    Y{i}(sub2ind(size(Y{i}),datap(index{i},2),datap(index{i},1))) = datap(index{i},4);  % image axis and projected data axis mapping
    U{i}(sub2ind(size(U{i}),datap(index{i},2),datap(index{i},1))) = datap(index{i},5);
    V{i}(sub2ind(size(V{i}),datap(index{i},2),datap(index{i},1))) = datap(index{i},6);
    image{i} = (cat(3, Y{i}, U{i}, V{i}));
     occupancy{i} = map{i} & 1;
end
end