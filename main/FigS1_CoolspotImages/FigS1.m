

imageDir = 'C:\Users\spatterson\Dropbox\Sara and Jay Shared\smooth monostratified ganglion cells\SmoothMonostratifiedRGC\main\FigS1_CoolspotImages\painted_images\';
cropDir = fullfile(fileparts(imageDir), 'cropped_images');
if ~exist(cropDir, 'dir')
    mkdir(cropDir);
end

% The advantage of cropping the images in MATLAB is that the number of
% pixels is preserved across images which makes it way easier to calculate
% the scale bars later on.

% I used the "Crop" option to find the right size for the images. The
% result is printed to the command line.
app = ImageStackApp(imageDir);

cropValues = [3, 91, 797, 663]; % x y w h

imageNames = string(ls(imageDir));
imageNames(1:3) = [];  % remove ".",  "..", "cropped_images"
numImages = numel(imageNames);

zValues = zeros(1, numImages);
for i = 1:numImages
    zValues(i) = str2double(extractBetween(imageNames(i), "_Z", "_X"));
end

for i = 1:numImages
    im = imread(fullfile(imageDir, imageNames(i)));
    im = imcrop(im, cropValues);
    imwrite(im, fullfile(cropDir, sprintf('FigS1_z%i.png', zValues(i))));
end

%% Scale Bar
umPerPix = 7.5/1000;  % 7.5 nm per pixel
scaleBarLength = 1;   % 1 micron scale bar

imWidth = cropValues(3) * umPerPix;
sbRelative = scaleBarLength / imWidth;

scaleBarPt = sbRelative * cropValues(3);

% Use scaleBarPt as the length of the scale bar line in Illustrator after
% placing the images but BEFORE resizing them. Once the scale bar line is
% drawn, make sure it's grouped with an image so that it resizes as the
% images are resized.