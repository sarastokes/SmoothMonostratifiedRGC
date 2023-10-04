classdef SMPaperRGC < handle

    properties (SetAccess = private)
        Neuron
    end

    methods
        function obj = SMPaperRGC(neuron)
            obj.Neuron = neuron;
        end
    end

    methods
        function xyz = getBipolarXYZ(obj, bcType)
            if nargin < 2
                xyz = obj.Neuron.getSynapseXYZ('RibbonPost');
                return
            end

            bcLinks = obj.Neuron.links(obj.Neuron.links.Type == "RibbonPost", :);

            switch lower(bcType)
                case 'db4'
                    xyz = bcLinks{ismember(bcLinks, "DB4"), 'SynapseXYZ'};
                case 'db5'
                    xyz = bcLinks{ismember(bcLinks, "DB5"), 'SynapseXYZ'};
                case 'giant'
                    xyz = bcLinks{ismember(bcLinks, "giant"), 'SynapseXYZ'};
                case 'midget'
                    xyz = bcLinks{ismember(bcLinks, ["mBC", "midget"]), 'SynapseXYZ'};
                case 'db6'
                    xyz = bcLinks{ismember(bcLinks, ["DB6"]), 'SynapseXYZ'};
                case 'unknown'
                    error('Not yet implemented!');
            end
        end

        function xyz = getAmacrineXYZ(obj)
            xyz = obj.Neuron.getSynapseXYZ('ConvPost');
        end

    end

    methods
        function ax = golgi(obj, varargin)
            ax = golgi(obj.Neuron,...
                'FaceAlpha', 1, 'Color', [0.15 0.15 0.15], varargin{:});
        end

        function [h1, h2] = plotIE(obj, varargin)
            ip = inputParser();
            ip.CaseSensitive = false;
            ip.KeepUnmatched = true;
            addParameter(ip, 'ScaleBar', false, @islogical);
            parse(ip, varargin{:});


            ax = obj.golgi(obj.Neuron, ip.Unmatched);
            h1 = mark3D(obj.getBipolarXYZ(),...
                'ax', ax, 'Color', hex2rgb('sky blue'));
            h2 = mark3D(obj.getAmacrineXYZ(),...
                'ax', ax, 'Color', rgb('peach'));
            set([h1, h2], 'MarkerFaceAlpha', 0.7, 'SizeData', 30);

            if ip.Results.ScaleBar
                obj.addScaleBar(ax);
            end
        end

        function h = addScaleBar(obj, ax)

            switch obj.Neuron.ID
                case 1321
                    xData = [215 235]; yData = [1 1]; zData = [0 0];
            end

            h = plot3(ax, xData, yData, zData,...
                'k', 'LineWidth', 1, 'Tag', 'ScaleBar');
        end
    end

    methods (Static)
        function cutoff = clipBipolar(ID, handle)

            if istext(ID)
                ID = convertStringsToChars(ID);
                ID = str2double(ID(2:end));
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
                flattenRender(findobj(handle, 'Tag', ['c', num2str(ID)]), 'i');
            end
            clipMesh(findobj(handle, 'Tag', ['c', num2str(ID)]), cutoff, false);
        end
    end
end