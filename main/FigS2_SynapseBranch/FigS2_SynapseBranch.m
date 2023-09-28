
imPath = fullfile(getSmoothMonoRepoDir(), 'main', 'FigS2_SynapseBranch');


%% Preprocess images for photoshop
rawImagePath = fullfile(imPath, 'raw_images');
adjImagePath = fullfile(imPath, 'adj_images');
if ~exist(adjImagePath, 'dir')
    mkdir(adjImagePath);
end

rawImageFiles = string(ls(rawImagePath));
rawImageFiles(1:2) = [];

for i = 1:numel(rawImageFiles)
    if exist(fullfile(adjImagePath, rawImageFiles(i)), 'file')
        continue;
    end
    rawImage = imread(fullfile(rawImagePath, rawImageFiles(i)));
    adjImage = imadjust(rgb2gray(rawImage));
    imwrite(adjImage, fullfile(adjImagePath, rawImageFiles(i)));
end

%% Crop painted images from photoshop
app = ImageStackApp(paintedImagePath);
cropValues = [];

