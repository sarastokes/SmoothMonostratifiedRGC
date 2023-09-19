function [hR, hA] = scatterIE(neuron, opts)

    arguments
        neuron
        opts.bins        {mustBeInteger} = 20
        opts.smoothFac   {mustBeInteger} = 1
        opts.mrk         char            = '.w'
        opts.cmap        double          = bone(256)
        opts.markers     logical         = true
        opts.xbound      double          = []
        opts.ybound      double          = []
        opts.dendrite    logical         = false
        opts.square      logical         = false
        opts.cbar        logical         = false
        opts.clevels     double          = 9
        opts.branch      logical         = false
    end

    ribbonXYZ = neuron.getSynapseXYZ('RibbonPost');
    amacrineXYZ = neuron.getSynapseXYZ('ConvPost');

    if opts.branch
        numPlots = 3;
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
                % Soma adjustment will cut the rest
            case 5370
                dendriteXYZ(dendriteXYZ(:,3) < 61, :) = [];
        end
    else
        numPlots = 2;
        dendriteXYZ = [NaN NaN NaN];
    end
    
    if isempty(opts.xbound)
        [xMin, xMax] = bounds([ribbonXYZ(:,1); amacrineXYZ(:,1); dendriteXYZ(:,1)]);
        opts.xbound = [xMin, xMax];
    end
    if isempty(opts.ybound)
        [yMin, yMax] = bounds([ribbonXYZ(:,2); amacrineXYZ(:,2); dendriteXYZ(:,2)]);
        opts.ybound = [yMin, yMax];
    end

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

    figure(); 
    set(gcf, 'DefaultAxesFontSize', 10);

    if numPlots == 3
        subplot(1,3,1); hold on;
        title('Dendrites');
        hD = scattercloud(dendriteXYZ(:,1), dendriteXYZ(:,2),...
            opts.bins, opts.smoothFac, opts.mrk, opts.cmap, opts.xbound, opts.ybound);
        originalLimits = [xlim(); ylim()];
        if opts.dendrite
            [~, h] = golgi(neuron, 'ax', gca, 'Color', 'k');
            set(h, 'FaceAlpha', 1);
        end
        hideAxes();
        cmap = slanCM('tempo', opts.clevels);
        %cmap = flipud(slanCM('bone', opts.clevels));
        cmap(end-1:end,:) = [];  % Remove darkest value to preserve dendrites
        colormap(gca, cmap);
        if opts.cbar
            cb = colorbar();
            cb.Layout.Tile = 'south';
            cb.Label.String = 'Dendrite Density';
        end
    end

    subplot(1,3,2); hold on;
    title('Bipolar Cell Input');
    hR = scattercloud(ribbonXYZ(:, 1), ribbonXYZ(:,2),...
        opts.bins, opts.smoothFac, opts.mrk, opts.cmap, opts.xbound, opts.ybound);
    axis tight equal;
    if opts.dendrite
        [~, h] = golgi(neuron, 'ax', gca, 'Color', 'k');
        set(h, 'FaceAlpha', 1);
    end
    hideAxes();
    cmap = slanCM('dense', opts.clevels);
    cmap(end-1:end,:) = [];  % Remove darkest value to preserve dendrites
    colormap(gca, cmap);
    if opts.cbar
        cb = colorbar();
        cb.Layout.Tile = 'south';
        cb.Label.String = 'Synapse Density';
    end

    subplot(1,3,3); hold on;
    hA = scattercloud(amacrineXYZ(:,1), amacrineXYZ(:,2),...
        opts.bins, opts.smoothFac, opts.mrk, opts.cmap, opts.xbound, opts.ybound);
    axis tight equal;
    if opts.dendrite
        [~, h] = golgi(neuron, 'ax', gca, 'Color', 'k');
        set(h, 'FaceAlpha', 1);
    end
    hideAxes();
    cmap = slanCM('OrRd', opts.clevels);
    cmap(end-1:end,:) = [];  % Remove darkest value to preserve dendrites
    colormap(gca, cmap);
    title('Amacrine Cell Input');

    if opts.cbar
        cb = colorbar();
        cb.Layout.Tile = 'south';
        cb.Label.String = 'Synapse Density';
    end     

    if ~opts.markers
        delete(hA(2));
        delete(hR(2));
        delete(hD(2));
    end

    % Match colormaps
    axHandles = findall(gcf, 'Type', 'axes');
    %cMax = max(vertcat(axHandles.CLim), [], "all");
    %set(axHandles, 'CLim', [0 cMax]);
    %fprintf('Colormap max = %.3f\n', cMax);

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
    %tightfig(gcf);
