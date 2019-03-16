function im_d = sliding_window_disparity(image1, image2, radius)
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
                    
            best_match = find_best_match(im1, im2, pixel, radius);
            disparity = pixel(2) - best_match(2);  % compute disparity
            im_d(row, column) = disparity;
            
        end
    end
    
    I = mat2gray(im_d);
    imshow(I)
    
end


function best_match = find_best_match(im1, im2, original, radius)
    best_match = [0, 0];
    best_fitness = 100000000000000000000000000000000;
    
    for column = 1+ radius : radius*2 + 1 : size(im1, 2) - radius  % Only one row needs to be windowed over.
        pixel = [original(1), column];
        fitness = compute_SSE_fitness(im1, im2, original, pixel, radius);

        % If better match was found:
        if fitness < best_fitness
            best_fitness = fitness;
            best_match = pixel;
        end

    end
end


function fitness = compute_SSE_fitness(im1, im2, original, new, radius)
    im1_window = im1(original(1) - radius : original(1) + radius, original(2) - radius : original(2) + radius);
    im2_window = im2(new(1) - radius : new(1) + radius, new(2) - radius : new(2) + radius);
    
    delta = double(im1_window) - double(im2_window);
    fitness = sum(delta(:).^2);
    
end
