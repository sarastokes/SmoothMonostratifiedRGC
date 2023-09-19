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

        function h = addScaleBar(obj, ax, opt)
            if nargin < 3
                opt = 0;
            end

            switch obj.Neuron.ID
                case 1321
                    xData = [215 235]; yData = [1 1]; zData = [0 0];
            end

            h = plot3(ax, xData, yData, zData,...
                'k', 'LineWidth', 1, 'Tag', 'ScaleBar');
        end
    end

    methods (Static)
        function clipBipolar(ID, handle)
            if nargin < 3
                handle = gca;
            end

            if istext(ID)
                ID = convertStringsToChars(ID);
                ID = str2double(ID(2:end));
            end

            switch ID
                case 19284
                    cutoff = 72;
                case 19331
                    cutoff = 70;
                case 21399
                    cutoff = 70;
                case 22114
                    cutoff = 74;
                case 22149
                    cutoff = 82;
                case 22138
                    cutoff = 68;
                case 22227
                    cutoff = 55;
                case 22260
                    cutoff = 70;
                case 22298
                    cutoff = 74;
                case 22311
                    cutoff = 67;
                case 22376
                    cutoff = 64;
                case 22491
                    cutoff = 60;
                case 22509
                    cutoff = 63.5;
                case 22679
                    cutoff = 67;
                case 23833
                    cutoff = 58;
                case 26772
                    cutoff = 74;
                case 29644
                    cutoff = 56;
                case {1321, 18269, 5063, 5370}
                    return
                otherwise
                    warning('No cutoff specified for c%u!', ID);
                    return
            end
            clipMesh(findobj(handle, 'Tag', ['c', num2str(ID)]), cutoff, false);
        end
    end
end