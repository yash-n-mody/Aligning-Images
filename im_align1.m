# Function for Sum of squared differences method
function [optimRowDisp, optimColDisp] = im_align1 (channel1, channel2)
  # book-keeping
  imageX = columns(channel1);
  imageY = rows(channel1);
  offX = round(imageX/20);
  offY = round(imageY/20);
  optimRowDisp = 0;
  optimColDisp = 0;
  optimSum = 0;
  optimSum = intmax();
  
  # pad both channels with zeroes upto max possible offset in each direction
  A = padarray(channel1, [offY, offX]);
  B = padarray(channel2, [offY, offX]);
  
  # loop over all possible displacements for this window size
  for dispRow = -offY:offY
    for dispCol = -offX:offX
      # vectorized logic for shifting channel2 by the current displacement
      # values, and then calculating squared differences for corresponding
      # values of channel1 (post shifting). 
      differences = (A((offY + 1):(end - offY), (offX + 1):(end - offX)) - B((offY + dispRow + 1):(end - (offY - dispRow)), (offX + dispCol + 1):(end - (offX - dispCol)))).^2;
      # Then add them all up. Because "SUM" of squared differences.
      tot = sum(differences(:));
      # more book-keeping
      if (tot <= optimSum)
        optimSum = tot;
        optimRowDisp = dispRow;
        optimColDisp = dispCol;
      endif
    endfor
  endfor
endfunction
