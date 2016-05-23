function [ output_args ] = buildDatabase( folder_name,dbName)

disp('Building');

%[filename, pathname] = uigetfile('*.png', 'Pick an Image file');

featArr={};
row=1;
folder_name=strcat(folder_name,'/');

srcFiles = dir(strcat(folder_name,'*.png'));  % the folder in which ur images exists
for k = 1 : length(srcFiles)
    filename = strcat(folder_name,srcFiles(k).name);
    img = imread(filename);
    img(img~=255)=0;

%     figure;imshow(img);
%     
    img=convertRGBtoGrayscale(img);
    % imgI=~img;
    % figure;imshow(imgI);

    % Takes the complement of the image. I.e. shape is now white and bg is
    % black

    imgInv=imcomplement(img);
    %figure;imshow(imgInv);

    % to get shape skeleton
    shapeSkel = bwmorph(imgInv,'skel',Inf);

%   figure;
%   imshow(shapeSkel)

%   Gives the branch point in shape skeleton. Not being used atm
    skelBranchpoints = bwmorph(shapeSkel,'branchpoints',1);

%   figure;
%   imshow(skelBranchpoints)
    noOfBranchPoints = sum(skelBranchpoints==1);
    noOfBranchPoints = sum(noOfBranchPoints);

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
    % featArr has all the final data!!
    featArr{row,1}=noOfBranchPoints;
    featArr{row,2}=filename;
    count=3;
    for i=1:size(img,1)
        for j=1:size(img,2)

            if shapeSkel(i,j)==1
                featArr{row,count}=distanceTransform(i,j);
                count=count+1;
            end

        end
    end
    
%     featArr=cell2mat(featArr);
%     dlmwrite('shapeFeatures.csv',featArr,'-append','delimiter',',');
    row=row+1;
end
dbNameComplete=char(strcat(dbName,'.mat'));
save(dbNameComplete,'featArr');

disp('Built');

end

