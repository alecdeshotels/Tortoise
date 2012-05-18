scarlett = imread('scarlett.jpg');
gpuScarlett = gpuArray(scarlett);
gpuHalf = gpuScarlett / 2
half = gather(gpuHalf);
imshow(half);
