pkg load image;

# since we have six images - all conveniently labelled.
for i = 1:6
  imagePath = ["raw/image" num2str(i) ".jpg"];
  unprocessedImage = imread(imagePath);

  # combine channels to get color  
  blueChannel = unprocessedImage(1:(end/3 + 1), 1:end);
  greenChannel = unprocessedImage(end/3:2*end/3, 1:end);
  redChannel = unprocessedImage(2*end/3:end, 1:end);
  colored = cat(3, redChannel, greenChannel, blueChannel);
  imagePath = ["image" num2str(i) "-color.jpg"];
  imwrite(colored, imagePath);
  
  # method 1: Sum of squared differences
  [x, y] = im_align1(blueChannel, greenChannel);
  printf("%d-ssd-green: [%3d, %3d]\n", i, x, y);
  greenChannel = padarray(greenChannel, [abs(x), abs(y)])(1 + abs(x) + x:end - (abs(x) - x), 1 + abs(y) + y:end - (abs(y) - y));
  [x, y] = im_align1(blueChannel, redChannel);
  printf("%d-ssd-red: [%3d, %3d]\n", i, x, y);
  redChannel = padarray(redChannel, [abs(x), abs(y)])(1 + abs(x) + x:end - (abs(x) - x), 1 + abs(y) + y:end - (abs(y) - y));
  imagePath = ["image" num2str(i) "-ssd.jpg"];
  colored = cat(3, redChannel, greenChannel, blueChannel);
  imwrite(colored, imagePath);

  # method 2: Normalized cross-correlation
  [x, y] = im_align2(blueChannel, greenChannel);
  printf("%d-ncc-green: [%3d, %3d]\n", i, x, y);
  greenChannel = padarray(greenChannel, [abs(x), abs(y)])(1 + abs(x) + x:end - (abs(x) - x), 1 + abs(y) + y:end - (abs(y) - y));
  [x, y] = im_align2(blueChannel, redChannel);
  redChannel = padarray(redChannel, [abs(x), abs(y)])(1 + abs(x) + x:end - (abs(x) - x), 1 + abs(y) + y:end - (abs(y) - y));
  printf("%d-ncc-red: [%3d, %3d]\n", i, x, y);
  imagePath = ["image" num2str(i) "-ncc.jpg"];
  colored = cat(3, redChannel, greenChannel, blueChannel);
  imwrite(colored, imagePath);
endfor