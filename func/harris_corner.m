 %%%Prewitt Operator Corner Detection.m
 %%%????--??????????
%%
clear;
 for nfigure=1:1
     
 switch nfigure  %????
    case  1 
         t='z1.jpg';
     case  2 
         t='z2.jpg';
     case  3 
         t='z3.jpg';
     case  4 
         t='z4.jpg';
     case  5 
         t='z5.jpg';
     case  6 
         t='z6.jpg';
 end
 % t1 = tic;                        %????
FileInfo = imfinfo(t);             % ?????????
Image = imread(t);                 % ????
% ???????(Intensity Image)
 if(strcmp('truecolor',FileInfo.ColorType) == 1) %???????
Image = im2uint8(rgb2gray(Image));   
 end    

 dx = [-1 0 1;-1 0 1;-1 0 1];  %dx???Prewitt????
Ix2 = filter2(dx,Image).^2;   
 Iy2 = filter2(dx',Image).^2;                                         
 Ixy = filter2(dx,Image).*filter2(dx',Image);

 %?? 9*9???????????????????
h= fspecial('gaussian',9,2);     
 A = filter2(h,Ix2);       % ???????Ix2??A 
 B = filter2(h,Iy2);                                 
 C = filter2(h,Ixy);                                  
 nrow = size(Image,1);                            
 ncol = size(Image,2);                             
 Corner = zeros(nrow,ncol); %??Corner??????????,???????1?????
                           %??????137?138??(row_ave,column_ave)??
%??t:?(i,j)????�???�???????????????????????
%?-t,+t?????????????????????????
t=20;
 %??????????????????????boundary????
%??????????????????
boundary=8;
 for i=boundary:nrow-boundary+1 
     for j=boundary:ncol-boundary+1
         nlike=0; %?????
        if Image(i-1,j-1)>Image(i,j)-t && Image(i-1,j-1)<Image(i,j)+t 
             nlike=nlike+1;
         end
         if Image(i-1,j)>Image(i,j)-t && Image(i-1,j)<Image(i,j)+t  
             nlike=nlike+1;
         end
         if Image(i-1,j+1)>Image(i,j)-t && Image(i-1,j+1)<Image(i,j)+t  
             nlike=nlike+1;
         end  
         if Image(i,j-1)>Image(i,j)-t && Image(i,j-1)<Image(i,j)+t  
             nlike=nlike+1;
         end
         if Image(i,j+1)>Image(i,j)-t && Image(i,j+1)<Image(i,j)+t  
             nlike=nlike+1;
         end
         if Image(i+1,j-1)>Image(i,j)-t && Image(i+1,j-1)<Image(i,j)+t  
             nlike=nlike+1;
         end
         if Image(i+1,j)>Image(i,j)-t && Image(i+1,j)<Image(i,j)+t  
             nlike=nlike+1;
         end
         if Image(i+1,j+1)>Image(i,j)-t && Image(i+1,j+1)<Image(i,j)+t  
             nlike=nlike+1;
         end
         if nlike>=2 && nlike<=6
             Corner(i,j)=1;%?????0?1?7?8????????i,j?
                          %?(i,j)?????????????
        end;
     end;
 end;

 CRF = zeros(nrow,ncol);    % CRF???????????,????
CRFmax = 0;                % ??????????????????? 
t=0.05;   
 % ??CRF
 %?????CRF(i,j) =det(M)/trace(M)??CRF???????????103??
%????t??????t=0.1??????????????????????
for i = boundary:nrow-boundary+1 
 for j = boundary:ncol-boundary+1
     if Corner(i,j)==1  %??????
        M = [A(i,j) C(i,j);
              C(i,j) B(i,j)];      
          CRF(i,j) = det(M)-t*(trace(M))^2;
         if CRF(i,j) > CRFmax 
             CRFmax = CRF(i,j);    
         end;            
     end
 end;             
 end;  

 count = 0;       % ?????????
t=0.01;         
 % ??????3*3???????????????
for i = boundary:nrow-boundary+1 
 for j = boundary:ncol-boundary+1
         if Corner(i,j)==1  %??????????
            if CRF(i,j) > t*CRFmax && CRF(i,j) >CRF(i-1,j-1) ......
                && CRF(i,j) > CRF(i-1,j) && CRF(i,j) > CRF(i-1,j+1) ......
                && CRF(i,j) > CRF(i,j-1) && CRF(i,j) > CRF(i,j+1) ......
                && CRF(i,j) > CRF(i+1,j-1) && CRF(i,j) > CRF(i+1,j)......
                && CRF(i,j) > CRF(i+1,j+1) 
             count=count+1;%??????count?1
             else % ???????i,j????????Corner(i,j)????????????
                Corner(i,j) = 0;     
             end;
         end; 
 end; 
 end; 
 % disp('????');
 % disp(count)
 figure,imshow(Image);      % display Intensity Image
 hold on; 
 % toc(t1)
 for i=boundary:nrow-boundary+1 
 for j=boundary:ncol-boundary+1
         column_ave=0;
         row_ave=0;
         k=0;
        if Corner(i,j)==1
             for x=i-3:i+3  %7*7??
                for y=j-3:j+3
                     if Corner(x,y)==1
 % ????????????????????????????????????????
                        row_ave=row_ave+x;
                         column_ave=column_ave+y;
                         k=k+1;
                     end
                 end
             end
         end
         if k>0 %????????           
              plot( column_ave/k,row_ave/k ,'r.');
         end
 end; 
 end; 

 end
