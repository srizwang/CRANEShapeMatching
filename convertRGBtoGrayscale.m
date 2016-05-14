function ret=convertRGBtoGrayscale(inputimg)

X=inputimg;
origSize=size(X);

% Determine if input includes a 3-D array 
threeD=(ndims(X)==3);

% Calculate transformation matrix
T=inv([1.0 0.956 0.621; 1.0 -0.272 -0.647; 1.0 -1.106 1.703]);
coef=T(1,:)';

if threeD
  %RGB
  % Shape input matrix so that it is a n x 3 array and initialize output
  % matrix  
  X=reshape(X(:),origSize(1)*origSize(2),3);
  sizeOutput=[origSize(1),origSize(2)];
  
  % Do transformation
  if isa(X,'double')||isa(X,'single')
    ret=X*coef;
    ret=min(max(ret,0),1);
  else
    %uint8 or uint16
    ret=imlincomb(coef(1),X(:,1),coef(2),X(:,2),coef(3),X(:,3), ...
                  class(X));
  end
  %Make sure that the output matrix has the right size
   ret=reshape(ret,sizeOutput);   

else
  ret=X * coef;
  ret=min(max(ret,0),1);
  ret=[ret,ret,ret];
end
