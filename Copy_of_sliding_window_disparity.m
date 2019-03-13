function sliding_window_disparity(image1, image2, measure, window_size)
    im1 = imread(image1);
    im2 = imread(image2);
    
    slide_window(im1, im2, measure, window_size)

end

function slide_window(im1, im2, measure, window_size)
    for row = 1:window_size:size(im1,1)
        for col = 1:window_size:size(im1,2)
           % if the window is out of bounds, take the remainder
           % of the pixels left to the image boundary
           if row + window_size > size(im1,1)
               window_end_row = size(im1,1);
           else
               window_end_row = row + window_size - 1;
           end
           
           if col + window_size > size(im1,2)
               window_end_col = size(im1,2);
           else
               window_end_col = col + window_size - 1;
           end 

           window = im1(row:window_end_row,col:window_end_col,:);
           compare_window(window, im2, measure)
        end
    end

end

function compare_window(window1, im2, measure)
    window_row_size = size(window1,1);
    window_col_size = size(window1,2);

    for row = 1:window_row_size:size(im2,1)
        for col = 1:window_col_size:size(im2,2)
            disp(window_row_size)
            disp(window_col_size)
            window_end_row = row + window_row_size - 1
            window_end_col = col + window_col_size - 1
            window2 = im2(row:window_end_row,col:window_end_col,:)
        end
    end
    
end

window = zeros(window_size, window_size, 3);
           if row - window_size / 2 < 1
               row1 = 1;
           else
               row1 = row - window_size / 2;
           end
           
           if row + window_size / 2 > size(im1,1)
               row2 = size(im1,1);
           else
               row2 = row + window_size / 2;
           end
           
           if col - window_size / 2 < 1
               col1 = 1;
           else
               col1 = col - window_size / 2;
           end
           
           if col + window_size / 2 > size(im1,2)
               col2 = size(im1,2);
           else
               col2 = col + window_size / 2;
           end
           
           window(row1:row2,col1:col2,:) = im1(row1:row2,col1:col2,:);
           compare_window(window, im2, measure, window_size)
