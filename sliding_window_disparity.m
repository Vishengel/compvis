function im_d = sliding_window_disparity(image1, image2, method, radius)
    im1 = imread(image1);
    im2 = imread(image2);
    
    % Init 2D array of size NxM with zeroes
    im_size = size(im1);
    im_d = zeros(im_size(1:2));
    
    % For each pixel in cropped/bounded image1:
    for row = 1 + radius : 1 : size(im1, 1) - radius
        fprintf('Working on row: %d\n', row);
        
        for column = 1 + radius : 1 : size(im1, 2) - radius
            pixel = [row, column];
            
            if method == 1
                best_match = match_using_SSE(im1, im2, pixel, radius);
            else
                best_match = match_using_NCC(im1, im2, pixel, radius);
            end
            
            disparity = pixel(2) - best_match(2);  % compute disparity
            im_d(row, column) = disparity;
            
        end
    end
    
    I = mat2gray(im_d);
    imshow(I)
    
end


function best_match = match_using_SSE(im1, im2, original, radius)
    best_fitness = 100000000000000000000000000000000;
    im1_window = im1(original(1) - radius : original(1) + radius, original(2) - radius : original(2) + radius);
    
    % Only one row needs to be windowed over:
    for column = 1+ radius : radius*2 + 1 : size(im1, 2) - radius  
        pixel = [original(1), column];
        
        im2_window = im2(pixel(1) - radius : pixel(1) + radius, pixel(2) - radius : pixel(2) + radius);
        
        delta = double(im1_window) - double(im2_window);
        fitness = sum(delta(:).^2);

        % If better match was found:
        if fitness < best_fitness
            best_fitness = fitness;
            best_match = pixel;
        end

    end
end


function best_match = match_using_NCC(im1, im2, original, radius)
    
    im1 = double(rgb2gray(im1));
    im2 = double(rgb2gray(im2));
    
    im1_window = im1(original(1) - radius : original(1) + radius, original(2) - radius : original(2) + radius);
    im2_range = im2( original(1) - radius : original(1) + radius , :);
    
   % Cross correlate the window in im1 with only the corresponsing rows of im2
    c = normxcorr2(im1_window, im2_range);
    
    [ypeak, xpeak] = find(c==max(c(:)));
    
    yoffSet = ypeak-size(im1_window, 1);
    xoffSet = xpeak-size(im1_window,2);
    
    peak = [yoffSet+1, xoffSet+1];
    
    % Find location of best match
    best_match = [original(1), peak(1, 2)];
    
end
