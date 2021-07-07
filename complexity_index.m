function fe = complexity_index(im)
ar = armodel(im,1);
bi = bfilter(im/255,1,[3,0.1],1)*255;
fe = fe_index(0.5*ar+0.5*bi,im,1);
%=======================================================
function ff = fe_index(img1,img2,tt)
ee = img2-img1;
xx = -255:255;
yy = round(ee(1:tt:end,1:tt:end));
[nn,~] = hist(yy(:),xx);
pp = (1+2*nn)/sum(1+2*nn);
ff = -sum(pp.*log2(pp));
%=======================================================
function B = bfilter(A,w,sigma,tt)
sigma_d = sigma(1);
sigma_r = sigma(2);
[X,Y] = meshgrid(-w:w,-w:w);
G = exp(-(X.^2+Y.^2)/(2*sigma_d^2));
dim = size(A);
B = zeros(dim);
for i = 1:tt:dim(1)
for j = 1:tt:dim(2)
iMin = max(i-w,1);
iMax = min(i+w,dim(1));
jMin = max(j-w,1);
jMax = min(j+w,dim(2));
I = A(iMin:iMax,jMin:jMax);
H = exp(-(I-A(i,j)).^2/(2*sigma_r^2));
F = H.*G((iMin:iMax)-i+w+1,(jMin:jMax)-j+w+1);
B(i,j) = sum(F(:).*I(:))/sum(F(:));
end
end
%=======================================================
function imgrec = armodel(imgin,tt)
sr=3;%search range
mr=1;%model range
imgt=padarray(imgin,[sr+mr sr+mr],'symmetric');
imgrec=zeros(size(imgin));
[m n]=size(imgt);
N=(2*sr+1)^2-1;
K=(2*mr+1)^2-1;
A=zeros(N,K+1);
for ii=mr+sr+1:tt:m-sr-mr
for jj=mr+sr+1:tt:n-sr-mr
con=1;
patch0=imgt(ii-mr:ii+mr,jj-mr:jj+mr);
for iii=-sr:+sr
for jjj=-sr:+sr
if iii==0&&jjj==0
continue;
end
patch=imgt(ii+iii-mr:ii+iii+mr,jj+jjj-mr:jj+jjj+mr);
vec=patch(:);
A(con,:)=vec';
con=con+1;
end
end
b=A(:,mr*(2*mr+2)+1);
A2=A;
A2(:,mr*(2*mr+2)+1)=[];
if rcond(A2'*A2)<1e-7
a = ones(K,1)/K;
else
a = A2\b;
end
vec0=patch0(:);
vec0(mr*(2*mr+2)+1)=[];
rec=vec0'*a;
imgrec(ii-sr-mr,jj-sr-mr)=rec;
end
end