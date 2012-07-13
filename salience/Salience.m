%preprocess image
input = imread('scarlett.jpg');
resized = imresize(input, Constants.IMSIZE);
gray = rgb2gray(resized);
%imwrite(gray, 'OutputImages/grayScale.jpg');

%matlab already does gaussian pyramid :)
blurred = gray;
directory = 'OutputImages/GaussianPyramid/';
for scale = 1:Constants.SCALES
    blurred = impyramid(blurred, 'reduce');
    reducedList{scale} = blurred;
    
    fileName = strcat(directory,'reduced',int2str(scale),'.jpg');
    %imwrite(reducedList{scale}, fileName);
    
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
    %imwrite(expandedList{scale}, fileName);
end

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
        %imwrite(intenseList{end}, fileName);
    end
end

%Create edge detected images for each orientation and blurriness
directory = 'OutputImages/EdgeDetection/';
allOriList = {};
for angle = 1:length(GaborFilters.filters)
    thisOriList = {};
    gf = GaborFilters.filters{angle};
    for scale = 1:length(expandedList)
        edgeDetected = imfilter(expandedList{scale}, gf, 'symmetric');
        %I may be better off not amplifying these values, but for now it
        %makes the results of edge detection more visible.
        edgeDetected = edgeDetected * 20;
        thisOriList{scale} = edgeDetected;
        imageIndex = strcat(int2str(angle),'_',int2str(scale));
        fileName = strcat(directory,'edge',imageIndex,'.jpg');
        %imwrite(thisOriList{scale}, fileName);
    allOriList{angle} = thisOriList;
    end
end

%Create orientation maps with difference of Gaussian
directory = 'OutputImages/OrientationMaps/';
allOMapList = {};
for angle = 1:length(allOriList)
    thisOMapList = {};
    thisOriList = allOriList{angle};
    for center = 2:4
        for delta = 3:4
            surround = center + delta;
            oriCenter = thisOriList{center};
            oriSurround = thisOriList{surround};
            oriMap = imabsdiff(oriCenter,oriSurround);
            thisOMapList = [thisOMapList;oriMap];
            imageIndex = strcat(int2str(center),'_',int2str(surround));
            imageIndex = strcat(int2str(angle),'_', imageIndex);
            fileName = strcat(directory,'oriMap',imageIndex,'.jpg');
            %imwrite(thisOMapList{end}, fileName);
        end
    end
    allOMapList{angle} = thisOMapList;
end

%Reduce feature maps for normalization
for scale = 1:Constants.NORMSCALE;
    for intIndex = 1:length(intenseList)
        intenseList{intIndex} = impyramid(intenseList{intIndex},'reduce');
    end
    for oriAIndex = 1:length(allOMapList)
        for oriSIndex = 1:length(allOMapList{oriAIndex})
            allOMapList{oriAIndex}{oriSIndex} = ...
                impyramid(allOMapList{oriAIndex}{oriSIndex},'reduce');
        end
    end
    %imwrite(intenseList{1}, 'OutputImages/shrunkenIntensityMap.jpg');
    %imwrite(allOMapList{1}{1}, 'OutputImages/shrunkenOriMap.jpg');
end
    
    











