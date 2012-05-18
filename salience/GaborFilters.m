classdef GaborFilters
    %GABORFILTERS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant = true)
        filters = {
            %22.5
            [-0.0053  0.0460  0.1219  0.0346 -0.0081;
	        -0.0297 -0.3283 -0.3698  0.0841  0.0705;
	        0.1118  0.4602  0.0000 -0.4602 -0.1118;
	        -0.0705 -0.0841  0.3698 0.3283  0.0297;
	         0.0081 -0.0346 -0.1219 -0.0460  0.0053]
            [] 
            [] 
            []};
    end
    
    methods
    end
    
end

