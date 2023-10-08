function [hD, hR, hA] = scatterIE(neuron, opts)
% Convenience function for quickly testing out colormap combos on Fig 3

    arguments
        neuron
        opts.bins        {mustBeInteger} = 20
        % Smoothing value for histogram
        opts.smoothFac   {mustBeInteger} = 1
        % Marker style
        opts.mrk         char            = '.w'
        % Keep the markers or delete
        opts.markers     logical         = true
        % Custom x and y limits
        opts.xbound      double          = []
        opts.ybound      double          = []
        % Add a render of the neuron?
        opts.dendrite    logical         = false
        % Should the bins have equal height and width
        opts.square      logical         = true
        % Custom colormap
        opts.cmap        double          = []
        % Should a colorbar be plotted for each?
        opts.cbar        logical         = false
        % How many levels in the colormap?
        opts.clevels     double          = 256
        % Normalize together vs individually
        opts.groupNorm  logical         = false
    end

    % Get the synapse annotations
    ribbonXYZ = neuron.getSynapseXYZ('RibbonPost');
    amacrineXYZ = neuron.getSynapseXYZ('ConvPost');

    % Get the dendrite annotations and remove soma + axon
    annotations = neuron.getCellNodes();
    annotations(2*annotations.Rum > 0.8*neuron.getSomaSize(false), :) = [];
    dendriteXYZ = annotations.XYZum;
    switch neuron.ID
        case 1321
            dendriteXYZ(dendriteXYZ(:,1) < 55,:) = [];
        case 18269
            dendriteXYZ(dendriteXYZ(:,3) < 45, :) = [];
        case 5063
            dendriteXYZ(dendriteXYZ(:,3) < 55, :) = [];
        case 5370
            dendriteXYZ(dendriteXYZ(:,3) < 61, :) = [];
    end

    if numel(opts.bins) == 1
        opts.bins = repmat(opts.bins, [1, 3]);
    end

    if isempty(opts.xbound)
        [xMin, xMax] = bounds([ribbonXYZ(:,1); amacrineXYZ(:,1); dendriteXYZ(:,1)]);
        opts.xbound = [xMin, xMax];
    end
    if isempty(opts.ybound)
        [yMin, yMax] = bounds([ribbonXYZ(:,2); amacrineXYZ(:,2); dendriteXYZ(:,2)]);
        opts.ybound = [yMin, yMax];
    end

    % Match the X and Y boundaries to get square bins
    if opts.square
        xyDiff = (yMax-yMin) - (xMax-xMin);
        if xyDiff > 0
            xMin = xMin - abs(xyDiff/2);
            xMax = xMax + abs(xyDiff/2);
            opts.xbound = [xMin xMax];
        else
            yMax = yMax + abs(xyDiff/2);
            yMin = yMin - abs(xyDiff/2);
            opts.ybound = [yMin yMax];
        end
    end

    cmap = opts.cmap;

    figure();
    set(gcf, 'DefaultAxesFontSize', 10);

    subplot(1,3,1); hold on;
    title('Dendrites');
    hD = scattercloud(dendriteXYZ(:,1), dendriteXYZ(:,2),...
        opts.bins(1), opts.smoothFac, opts.mrk, opts.cmap, opts.xbound, opts.ybound);
    originalLimits = [xlim(); ylim()];
    if opts.dendrite
        [~, h] = golgi(neuron, 'ax', gca, 'Color', 'k');
        set(h, 'FaceAlpha', 1);
    end
    hideAxes(); drawnow;
    if isempty(opts.cmap)
        cmap = slanCM('tempo', opts.clevels);
        % Remove darkest value to preserve dendrites
        cmap(end-1:end,:) = [];
    end
    colormap(gca, cmap); drawnow;

    subplot(1,3,2); hold on;
    title('Bipolar Cell Input');
    hR = scattercloud(ribbonXYZ(:, 1), ribbonXYZ(:,2),...
        opts.bins(2), opts.smoothFac, opts.mrk, opts.cmap, opts.xbound, opts.ybound);
    axis tight equal; drawnow;
    if opts.dendrite
        [~, h] = golgi(neuron, 'ax', gca, 'Color', 'k');
        set(h, 'FaceAlpha', 1);
    end
    hideAxes();
    if isempty(opts.cmap)
        cmap = slanCM('dense', opts.clevels);
        % Remove darkest value to preserve dendrites
        cmap(end-1:end,:) = [];
    end
    colormap(gca, cmap); drawnow;

    subplot(1,3,3); hold on;
    hA = scattercloud(amacrineXYZ(:,1), amacrineXYZ(:,2),...
        opts.bins(3), opts.smoothFac, opts.mrk, opts.cmap, opts.xbound, opts.ybound);
    axis tight equal; drawnow;
    if opts.dendrite
        [~, h] = golgi(neuron, 'ax', gca, 'Color', 'k');
        set(h, 'FaceAlpha', 1);
    end
    hideAxes();
    if isempty(opts.cmap)
        cmap = slanCM('OrRd', opts.clevels);
        % Remove darkest value to preserve dendrites
        cmap(end-1:end,:) = [];
    end
    colormap(gca, cmap);
    title('Amacrine Cell Input'); drawnow;

    % Always delete dendrite markers if neuron was plotted. Others by request
    if opts.dendrite
        delete(hD(2)); hD(2) = [];
    end
    if ~opts.markers
        delete(hA(2)); hA(2) = [];
        delete(hR(2)); hR(2) = [];
    end

    % Match colormaps
    axHandles = findall(gcf, 'Type', 'axes');
    if opts.groupNorm
        cMax = max(vertcat(axHandles.CLim), [], "all");
        set(axHandles, 'CLim', [0 cMax]);
        fprintf('Colormap max = %.3f\n', cMax);
    else
        for i = 1:numel(axHandles)
            axHandles(i).CLim(1) = 0;
        end
    end

    if opts.cbar
        for i = 1:numel(axHandles)
            cb = colorbar(axHandles(i));
            cb.Layout.Tile = 'south';
            if i == 3
                cb.Label.String = "Dendrite Density";
            else
                cb.Label.String = 'Synapse Density';
            end
        end
    end

    switch neuron.ID
        case 1321
            xlim(axHandles, [originalLimits(1,1), axHandles(1).XLim(2)]);
        case 18269
            h = findall(gcf, 'Tag', 'c18269');
            arrayfun(@(x) clipMesh(x, 38, true), h);
        case 5063
            h = findall(gcf, 'Tag', 'c5063');
            arrayfun(@(x) flattenRender(x, 'i'), h);
            arrayfun(@(x) clipMesh(x, 67, true), h);
        case 5370
            h = findall(gcf, 'Tag', 'c5370');
            arrayfun(@(x) flattenRender(x, 'i'), h);
            arrayfun(@(x) clipMesh(x, 69, true), h);
    end
    figPos(gcf, 1.4, 1);
    tightfig(gcf);
