
function [ff]=complexity_feature(image_r,~,occupancy_r)
% RGB to LMN colorspace 
Lr=cell(6,1);Mr=cell(6,1);Nr=cell(6,1); ff=cell(6,1);
for i=1:1:6
[Lr{i,1},Mr{i,1},Nr{i,1}]=RGB2LMN(image_r{i,1});
ff{i,1}=complexity_index(Lr{i,1}(occupancy_r{i,1}));
i
end


