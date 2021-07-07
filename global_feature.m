
function [kld_l,kld_m,kld_n]=global_feature(image_r,map_r,occupancy_r,image_d,map_d,occupancy_d)
%% preprocessing
[image_r, map_r, occupancy_r, Lcounts_r, Mcounts_r, Ncounts_r, Lcenters_r, Mcenters_r, Ncenters_r]=demo_his_6(image_r,map_r,occupancy_r);
[image_d, map_d, occupancy_d, Lcounts_d, Mcounts_d, Ncounts_d, Lcenters_d, Mcenters_d, Ncenters_d]=demo_his_6(image_d,map_d,occupancy_d);
%% probability density
Ldes_r=cell(6,1);Mdes_r=cell(6,1);Ndes_r=cell(6,1);
Ldes_d=cell(6,1);Mdes_d=cell(6,1);Ndes_d=cell(6,1);
for i=1:1:6
    lsp_r=Lcounts_r{i,1};lsp_d=Lcounts_d{i,1};
    lsum_r=sum(lsp_r); lsum_d=sum(lsp_d);
    Ldes_r{i,1}=lsp_r/lsum_r;Ldes_d{i,1}=lsp_d/lsum_d;
    
    msp_r=Mcounts_r{i,1};msp_d=Mcounts_d{i,1};
    msum_r=sum(msp_r); msum_d=sum(msp_d);
    Mdes_r{i,1}=msp_r/msum_r;Mdes_d{i,1}=msp_d/msum_d;
    
    nsp_r=Ncounts_r{i,1};nsp_d=Ncounts_d{i,1};
    nsum_r=sum(nsp_r); nsum_d=sum(nsp_d);
    Ndes_r{i,1}=nsp_r/nsum_r;Ndes_d{i,1}=nsp_d/nsum_d;
end
%% KLD 
kld_l=zeros(6,1);kld_m=zeros(6,1);kld_n=zeros(6,1);
for i=1:1:6
    kld_l(i,1)=kldiv(Lcenters_r{i,1},Ldes_r{i,1},Ldes_d{i,1},'js');
    kld_m(i,1)=kldiv(Mcenters_r{i,1},Mdes_r{i,1},Mdes_d{i,1},'js');
    kld_n(i,1)=kldiv(Ncenters_r{i,1},Ndes_r{i,1},Ndes_d{i,1},'js');
end


