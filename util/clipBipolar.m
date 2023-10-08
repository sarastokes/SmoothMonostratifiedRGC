
function cutoff = clipBipolar(ID, parentHandle)
% CLIPBIPOLAR
%
% Syntax:
%   clipBipolar(ID)
%   clipBipolar(ID, parentHandle)
%   cutoff = clipBipolar(ID, parentHandle)
%
% Inputs:
%   ID          double or char/string
%       The neuron ID or tag (e.g. 19331 or "c19331")
% Optional inputs:
%   parentHandle        axis or figure handle (default = gca)
%       The graphics object containing the render to clip
%
% Optional outputs:
%   cutoff              double
%       The Z-axis cutoff used to crop the render
%
% Examples:
%   % Clip c19331 to only show axon terminal
%   ax = golgi(Neuron(19331, 'i'));
%   clipBipolar(19331, ax)
%
% History:
%   12Sep2023 - SSP
% -------------------------------------------------------------------------

    if ischar(ID) || isstring(ID)
        ID = convertStringsToChars(ID);
        ID = str2double(ID(2:end));
    else
        assert(isa(ID, "double"),...
            "ID must be a number or a char/string tag (e.g., 'c1321')");
    end

    if nargin < 2
        parentHandle = gca;
    end

    if ismember(ID, [7122, 9725, 9734, 19513, 22260, 22927, 21374, 22499, 23855, 26914, 27142, 27316, 28304, 28313, 30624, 43194, 51071, 51073, 51791, 53255, 53261])
        cutoff = [];
        return
    end

    flatFlag = false;

    switch ID
        case 9084
            cutoff = 82;
        case 9336
            cutoff = 73;
        case 11043
            cutoff = 55;
        case 11045
            cutoff = 57;
        case 12685
            cutoff = 80;
        case 12747
            cutoff = 73.2;
        case 19235
            cutoff = 59;
        case 19284
            cutoff = 72;
        case 19331
            cutoff = 70;
        case 21393
            cutoff = 80;
        case 21399
            cutoff = 70;
        case 21405
            cutoff = 75;
        case 21409
            cutoff = 78;
        case 21451
            cutoff = 80;
            flatFlag = true;
        case 21510
            cutoff = 77;
        case 21768
            cutoff = 84;
        case 21842
            cutoff = 77;
        case 21959
            cutoff = 51;
        case 22114
            cutoff = 74;
        case 22118
            cutoff = 65;
        case 22149
            cutoff = 82;
        case 22138
            cutoff = 68;
        case 22162
            cutoff = 55;
        case 22168
            cutoff = 62;
        case 22219
            cutoff = 54;
        case 22227
            cutoff = 55;
        case 22260
            cutoff = 70;
        case 22262
            cutoff = 77;
        case 22298
            cutoff = 74;
        case 22311
            cutoff = 67;
        case 22327
            cutoff = 80; % double
        case 22374
            cutoff = 58.5;
        case 22376
            cutoff = 64;
        case 22394
            cutoff = 62;
        case 22420
            cutoff = 54;
        case 22424
            cutoff = 55;
        case 22490
            cutoff = 69;
        case 22491
            cutoff = 60;
        case 22494
            cutoff = 58;
        case 22509
            cutoff = 63.5;
        case 22524
            cutoff = 64;
        case 22537
            cutoff = 61;
        case 22555
            cutoff = 70;
        case 22563
            cutoff = 70;
        case 22565
            cutoff = 74;
        case 22601
            cutoff = 54;
        case 22615
            cutoff = 50;
        case 22656
            cutoff = 74;
        case 22663
            cutoff = 67;
        case 22679
            cutoff = 67;
        case 22828
            cutoff = 50;
        case 22898
            cutoff = 63;
        case 22903
            cutoff = 47;
        case 22920
            cutoff = 62;
        case 22926
            cutoff = 64;
        case 22939
            cutoff = 48;
        case 22963
            cutoff = 43;
        case 23755
            cutoff = 53;
        case 23674
            cutoff = 45;
        case 23833
            cutoff = 55;%58;
        case 26772
            cutoff = 74;
        case 27097
            cutoff = 84;
            flatFlag = true;
        case 28495
            cutoff = 45;
        case 28680
            cutoff = 62;
        case 29129
            cutoff = 50;
        case 29644
            cutoff = 63;
        case 30173
            cutoff = 81;
        case 41638
            cutoff = 55;
        case 44964
            cutoff = 45;
        case 45144
            cutoff = 77;
        case 45146
            cutoff = 52;
        case 45916
            cutoff = 67;
        case 47872
            cutoff = 60;
        case 51063
            cutoff = 74;
        case 51772
            cutoff = 70;
        case 53247
            cutoff = 60;
        case 53249
            cutoff = 56;
        case {1321, 18269, 5063, 5370}
            return
        otherwise
            warning('No cutoff specified for c%u!', ID);
            return
    end

    if nargin < 2
        cutoff = [];
        return
    end

    if flatFlag
        flattenRender(findobj(parentHandle, 'Tag', ['c', num2str(ID)]), 'i');
    end

    clipMesh(findobj(parentHandle, 'Tag', ['c', num2str(ID)]), cutoff, false);