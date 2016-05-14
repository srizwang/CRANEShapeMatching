function [ output_args ] = findShapeFunction( dbname,imgname,filename,number )

% FIND SHAPE

% clc
% clear all;
% close all;

% Select the database to load
load(dbname);

% Select the query image
featArr1={};
row=1;
img = imread(imgname);
img(img~=255)=0;
figure;imshow(img);
%figure;    
img=rgb2gray(img);
% imgI=~img;
% figure;imshow(imgI);



% Takes the complement of the image. I.e. shape is now white and bg is
% black
imgInv=imcomplement(img);
%figure;imshow(imgInv);




% To get shape skeleton
shapeSkel = bwmorph(imgInv,'skel',Inf);
%   figure;
%   imshow(shapeSkel)




%   Gives the branch point in shape skeleton
skelBranchpoints = bwmorph(shapeSkel,'branchpoints',1);
% figure;
% imshow(skelBranchpoints)
noOfBranchPoints = sum(skelBranchpoints==1);
noOfBranchPoints = sum(noOfBranchPoints);




%% to remove the last branchpoint, by checking if its below image half
[roww,coll]=find(skelBranchpoints);
skelBranchPointIndex=[roww,coll];
skelBranchPointIndex=sortrows(skelBranchPointIndex);
lastBranch=0;
imgrows=size(img,1);
imgcols=size(img,2);
for i=1:size(skelBranchPointIndex,1)
    if(skelBranchPointIndex(i,1)>(imgrows/2))
        imgrows=skelBranchPointIndex(i,1);
    end
end
%   figure;
%   imshow(skelBranchpoints)



%   Gives the end points in shape skeleton. Not being used atm
skelEndpoints = bwmorph(shapeSkel,'endpoints',1);
%   figure;
%   imshow(skelEndpoints)



%   To get the binary image do calculate distance transform
imgBinary=im2bw(img, 0.5);



%Distance transform
distanceTransform = bwdist(imgBinary);
distanceTransform_ToShowGrayScale = uint8(distanceTransform);
%   figure;
%   imshow(distanceTransform_ToShowGrayScale)




% Get distance transforms along the skeleton, and this will be the feature
% of the shape
featArr1{row,1}=noOfBranchPoints;
featArr1{row,2}=filename;
count=3;
for i=1:imgrows
    for j=1:size(img,2)

        if shapeSkel(i,j)==1
            featArr1{row,count}=distanceTransform(i,j);
            count=count+1;
        end

    end
end
a=1;

resultSet={};
errorArray={};
j=1;
for i=1:size(featArr,1)
    error=0;
    sumOfError=0;
%    if featArr{i,1}==featArr1{1,1}
%         img=imread(featArr{i,2});
%         imshow(img);
%         pause (1);

    tempFeatArr=featArr(i,:);
    tempFeatArr=tempFeatArr(~cellfun('isempty',tempFeatArr));
    
    minSize=min(size(tempFeatArr,2),size(featArr1,2));
    
    e1=cell2mat(featArr1(1,3:minSize));
    e2=cell2mat(tempFeatArr(1,3:minSize));
    
    errors=abs(e1-e2);
    sumOfError=sum(errors)
    errorArray{j,1}=sumOfError;
    errorArray{j,2}=featArr{i,2};
    j=j+1;
%         img=imread(featArr{i,2});
%         imshow(img);
%         pause (2);
        clc
    
%    end
    
end


sortedErrorArray=sortrows(errorArray);
%close all
figure;


% This is a subplot command. This is responsible for showing all the
% results as a grid in the end. Here, subplot(i,j,k) :: i*j represent the
% total number of results in the grid. So it'll have i rows, j columns, and
% i*j total results. The value of k is set to i*j, so that it can iterate
% over all the grid elements (using a for loop) and can show result accordingly.

for i=1:number
    subplot(2,(number/2),i);
    imshow(sortedErrorArray{i,2});
    title(strcat('match ',int2str(i)));
    

end
    
    




end

