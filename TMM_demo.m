%% Date 2021.1.14
%% Author: Qi Yang (Any question, please contact:yang_littleqi@sjtu.edu.cn)
%% Affiliation: Shanghai Jiao Tong University
%% If you use our code, please cite our paper: Predicting the perceptual quality of point cloud: A 3D-to-2D projection-based exploration
%% ****************************************************************************************************************
T=0.001;wei=0.4;k1=0.1;k2=25;k3=15;
a=0.3;b=0.4;c=0.1;d=0.1;e=0.05;f=0.05;
%% reference point cloud       
name_r=('redandblack.ply'); 
%% distorted point cloud
pt1=pcread(name_r);
name_d=('redandblack_0_0.ply');            
pt2=pcread(name_d);

[image_r, map_r, ~, ~, ~, occupancy_r ] = getProjection_image( pt1);
complex_feature=complexity_feature(image_r,map_r,occupancy_r);
[image_d, map_d, ~, ~, ~, occupancy_d ] = getProjection_image( pt2);

[obmos_kld_l,~,~]=global_feature(image_r,map_r,occupancy_r,image_d,map_d,occupancy_d);
[obmos_sim_l,obmos_sim_m,obmos_sim_n]=local_feature(image_r,map_r,occupancy_r,image_d,map_d,occupancy_d);

obmosl=a*obmos_kld_l(1,1)+b*obmos_kld_l(2,1)+c*obmos_kld_l(3,1)+d*obmos_kld_l(4,1)+e*obmos_kld_l(5,1)+f*obmos_kld_l(6,1);
obmos_global=1-obmosl;
obmos_sobel_lsim=a*obmos_sim_l(1,1)/(complex_feature{1,1}^wei)+b*obmos_sim_l(2,1)/(complex_feature{2,1}^wei)+c*obmos_sim_l(3,1)/(complex_feature{3,1}^wei)+d*obmos_sim_l(4,1)/(complex_feature{4,1}^wei)+e*obmos_sim_l(5,1)/(complex_feature{5,1}^wei)+f*obmos_sim_l(6,1)/(complex_feature{6,1}^wei);
obmos_sobel_msim=a*obmos_sim_m(1,1)/(complex_feature{1,1}^wei)+b*obmos_sim_m(2,1)/(complex_feature{2,1}^wei)+c*obmos_sim_m(3,1)/(complex_feature{3,1}^wei)+d*obmos_sim_m(4,1)/(complex_feature{4,1}^wei)+e*obmos_sim_m(5,1)/(complex_feature{5,1}^wei)+f*obmos_sim_m(6,1)/(complex_feature{6,1}^wei);
obmos_sobel_nsim=a*obmos_sim_n(1,1)/(complex_feature{1,1}^wei)+b*obmos_sim_n(2,1)/(complex_feature{2,1}^wei)+c*obmos_sim_n(3,1)/(complex_feature{3,1}^wei)+d*obmos_sim_n(4,1)/(complex_feature{4,1}^wei)+e*obmos_sim_n(5,1)/(complex_feature{5,1}^wei)+f*obmos_sim_n(6,1)/(complex_feature{6,1}^wei);
obmos_local=(k1*(obmos_sobel_lsim)+k2*(obmos_sobel_msim)+k3*(obmos_sobel_nsim))/(k1+k2+k3);
obmos=obmos_local*obmos_global;
fprintf('Objective Score: %d\n',obmos);
