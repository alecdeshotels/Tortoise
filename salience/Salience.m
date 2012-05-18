%preprocess image
input = imread('anime.jpg');
resized = imresize(input, Constants.IMSIZE);
gray = rgb2gray(resized);
imwrite(gray, 'OutputImages/grayScale.jpg');

%matlab already does gaussian pyramid :)
blurred = gray;
directory = 'OutputImages/GaussianPyramid/';
for scale = 1:Constants.SCALES
    blurred = impyramid(blurred, 'reduce');
    reducedList{scale} = blurred;
    
    fileName = strcat(directory,'reduced',int2str(scale),'.jpg');
    imwrite(reducedList{scale}, fileName);
    
    expanded = blurred;
    for expansions = 1:scale
        expanded = impyramid(expanded, 'expand');
        if expansions % 2 = 0
            expanded = padarray(expanded,[1 1], 'replicate', 'post');
        else
            expanded = padarray(expanded,[1 1], 'replicate', 'pre');
        end
    end
    expandedList{scale} = expanded;
    fileName = strcat(directory,'expanded',int2str(scale),'.jpg');
    imwrite(expandedList{scale}, fileName);
end


%{
%create gaussian pyramid
load('gausFilter.mat', 'gausFilter');
blur = gray;
directory = 'OutputImages/GaussianPyramid/';
for scale = 1:Constants.SCALES
    %generate reduced images
    blur = imfilter(blur, gausFilter, 'symmetric');
    blur = blur(2:2:end,2:2:end);
    reducedList{scale} = blur;
    fileName = strcat(directory,'reduced',int2str(scale),'.jpg');
    imwrite(reducedList{scale}, fileName);
    
    
    %expand them to create blurred images
    prevExp = blur;
    for expansions = 1:scale
        currExp = imresize(prevExp, size(prevExp)*2);
        %expansion is based on parity.  For example each even row and
        %even column of the expanded image corresponds to weights obtained
        %from only the even rows and columns of the filter * 4.
        

        for rParity = 1:2
            for cParity = 1:2
                expFilter = gausFilter*0;
                partFilter = gausFilter(rParity:2:end,cParity:2:end);
                expFilter(rParity:2:end,cParity:2:end) = partFilter;
                expFilterred = imfilter(prevExp, expFilter, 'symmetric');
                expFilterred = expFilterred * Constants.EXPAMPLIFY;
                currExp(rParity:2:end,cParity:2:end) = expFilterred;
            end
        end
        
        
        
        prevExp = currExp;
    end
    expandedList{scale} = currExp;
    fileName = strcat(directory,'expanded',int2str(scale),'.jpg');
    imwrite(expandedList{scale}, fileName);
end
%}

%Create intensity maps with difference of Gaussian
directory = 'OutputImages/IntensityMaps/';
intenseList = {};
for center = 2:4
    for delta = 3:4
        surround = center + delta;
        intenseCenter = expandedList{center};
        intenseSurround = expandedList{surround};
        intenseMap = imabsdiff(intenseCenter,intenseSurround);
        intenseList = [intenseList;intenseMap];
        imageIndex = strcat(int2str(center),'_',int2str(surround));
        fileName = strcat(directory,'intense',imageIndex,'.jpg');
        imwrite(intenseList{end}, fileName);
    end
end

%Create edge detected images for each orientation and blurriness
directory = 'OutputImages/OrientationMaps/';
gf = GaborFilters.filters{1}
edgetest2 = imfilter(expandedList{1}, gf, 'symmetric');

edgetest3 = imfilter(expandedList{2}, gf, 'symmetric');

edgetest = imabsdiff(edgetest2,edgetest3);
edgetest = double(edgetest)./double(max(edgetest(:)));
imshow(edgetest);




