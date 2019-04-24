function im_Cut = BR_Image_Cut(im_RGB, mStart, mEnd, nStart, nEnd)

    im_Cut = im_RGB(mStart:mEnd, nStart:nEnd, :);

end