function [image, map, occupancy, Lcounts, Mcounts, Ncounts, Lcenters, Mcenters, Ncenters]=demo_his_6(image,map,occupancy)

%% RGB to LMN colorspace 
Lr=cell(6,1);Mr=cell(6,1);Nr=cell(6,1);
for i=1:1:6
[Lr{i,1},Mr{i,1},Nr{i,1}]=RGB2LMN(image{i,1});
end

%% histogram-Lr,Mr,Nr
Lcounts=cell(6,1);Lcenters=cell(6,1);
Mcounts=cell(6,1);Mcenters=cell(6,1);
Ncounts=cell(6,1);Ncenters=cell(6,1);
for i=1:1:6
L=Lr{i,1};M=Mr{i,1};N=Nr{i,1};
L=L(:);M=M(:);N=N(:);
[Lcounts{i},Lcenters{i}]=hist(L(occupancy{i}),30);
[Mcounts{i},Mcenters{i}]=hist(M(occupancy{i}),30);
[Ncounts{i},Ncenters{i}]=hist(N(occupancy{i}),30);
end
