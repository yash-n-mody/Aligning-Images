# Function for Normalized Cross Correlation method
function [optimRowDisp, optimColDisp] = im_align2 (channel1, channel2)
  # book-keeping
  imageX = columns(channel1);
  imageY = rows(channel1);
  offX = round(imageX/20);
  offY = round(imageY/20);
  optimRowDisp = 0;
  optimColDisp = 0;
  optimCab = 0;
  optimCab = -intmax();

  # typecasting all elements of array so that they can support decimals and negatives
  for i = 1:imageY
    for j = 1:imageX
      channel1(i, j) = double(channel1(i, j));
      channel2(i, j) = double(channel2(i, j));
    endfor
  endfor

  # intensity normalisation - each element in A is subtracted by mean of A 
  # and divided by std. dev of A. A is then padded with zeroes 
  # by the maximum offsets in each direction
  Abar = mean(channel1(:));
  Adev = std(channel1(:));
  A = (channel1 .- Abar)./Adev;
  A = padarray(A, [offY, offX]);

  # intensity normalisation - each element in B is subtracted by mean of B 
  # and divided by std. dev of B. B is then padded with zeroes 
  # by the maximum offsets in each direction
  Bbar = mean(channel2(:));
  Bdev = std(channel2(:));
  B = (channel2 .- Bbar)./Bdev;
  B = padarray(B, [offY, offX]);

  # loop over all possible displacements for this offset size
  for dispRow = -offY:offY
    for dispCol = -offX:offX
      # calculate correlation array
      Cab = A((offY + 1):(end - offY), (offX + 1):(end - offX)) .* B((offY + dispRow + 1):(end - (offY - dispRow)), (offX + dispCol + 1):(end - (offX - dispCol)));
      # add all of it up to get actual correlation
      tot = sum(Cab(:));
      if (tot >= optimCab)
        optimCab = tot;
        optimRowDisp = dispRow;
        optimColDisp = dispCol;
      endif
    endfor
  endfor
endfunction
