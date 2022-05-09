function [s]=similarity(I,A,T)
[m,n]=size(I);
% for i=1:1:m
%     for j=1:1:n
%         s(i,j)=(2*I(i,j)*A(i,j)+T)/(I(i,j)*I(i,j)+A(i,j)*A(i,j)+T);
%     end
% end
s=(2*I.*A+T)./(I.^2+A.^2+T);