function iimg = integralImage2(img)

iimg = zeros(size(img));

if numel(size(img)) == 2
    iimg(1,:) = img(1,:);
    for y = 2:size(img,1)
        iimg(y,:) = iimg(y-1,:) + img(y,:);
    end
    for x = 2:size(img,2)
        iimg(:,x) = iimg(:,x-1) + iimg(:,x);
    end
else
    iimg(1,:,:) = img(1,:,:);
    for y = 2:size(img,1)
        iimg(y,:,:) = iimg(y-1,:,:) + img(y,:,:);
    end
    for x = 2:size(img,2)
        iimg(:,x,:) = iimg(:,x-1,:) + iimg(:,x,:);
    end
    for z = 2:size(img,3)
        iimg(:,:,z) = iimg(:,:,z-1) + iimg(:,:,z);
    end
end