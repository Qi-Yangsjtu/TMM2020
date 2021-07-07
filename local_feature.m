
function [obj_l,obj_m,obj_n]=local_feature(image_r,map_r,occupancy_r,image_d,map_d,occupancy_d)
%% RGB to LMN colorspace 
Lr=cell(6,1);Mr=cell(6,1);Nr=cell(6,1); 
Ld=cell(6,1);Md=cell(6,1);Nd=cell(6,1);
for i=1:1:6
[Lr{i,1},Mr{i,1},Nr{i,1}]=RGB2LMN(image_r{i,1});
[Ld{i,1},Md{i,1},Nd{i,1}]=RGB2LMN(image_d{i,1});
end

%% MN similarity measurement
T=0.0001;
M_sim=cell(6,1); N_sim=cell(6,1);L_sim=cell(6,1);
for i=1:1:6
    L_sim{i,1}=similarity(Lr{i,1},Ld{i,1},T);
    M_sim{i,1}=similarity(Mr{i,1},Md{i,1},T);
    N_sim{i,1}=similarity(Nr{i,1},Nd{i,1},T);
end
%% pooling
w_r=cell(6,1);w_d=cell(6,1);w=cell(6,1);occupancy=cell(6,1);
for i=1:1:6
    w_r{i,1}=edge(map_r{i,1},'sobel');
    w_d{i,1}=edge(map_d{i,1},'sobel');
    w{i,1}=max(w_r{i,1},w_d{i,1});
    
    
    occupancy{i,1}=occupancy_r{i,1}|occupancy_d{i,1};
    w{i,1}=w{i,1}&occupancy{i,1};

end
obj_m=zeros(6,1);obj_n=zeros(6,1);obj_l=zeros(6,1);
for i=1:1:6
    obj_l(i,1)=sum(sum(w{i,1}.*L_sim{i,1}))/sum(sum(w{i,1}));
    obj_m(i,1)=sum(sum(w{i,1}.*M_sim{i,1}))/sum(sum(w{i,1}));
    obj_n(i,1)=sum(sum(w{i,1}.*N_sim{i,1}))/sum(sum(w{i,1}));
end






