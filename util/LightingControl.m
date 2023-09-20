classdef LightingControl < handle

    properties (Access = private)
        axHandle
        lights
        Figure
    end

    properties (Dependent)
        numLights
    end

    methods
        function obj = LightingControl(axHandle)
            obj.axHandle = axHandle;
            obj.lights = findall(obj.axHandle, 'Type', 'light');

            obj.createUi();
        end

        function value = get.numLights(obj)
            value = numel(obj.lights);
        end
    end

    methods (Access = private)
        function onSliderChangedAzimuth(obj, src, ~)
            idx = str2double(src.Tag);
            [az, el] = lightangle(obj.lights(idx));
            lightangle(obj.lights(idx), src.Value, el);
            drawnow;
        end

        function onSliderChangedElevation(obj, src, ~)
            idx = str2double(src.Tag);
            [az, el] = lightangle(obj.lights(idx));
            lightangle(obj.lights(idx), az, src.Value);
            drawnow;
        end
    end

    methods (Access = private)
        function createUi(obj)
            obj.Figure = uifigure('Name', 'LightingControl');

            layout = uigridlayout(obj.Figure, [obj.numLights 1],...
                "ColumnWidth", {"1x"});

            for i = 1:obj.numLights
                obj.addLightControl(layout, i);
            end
        end

        function addLightControl(obj, parent, idx)
            [az, el] = lightangle(obj.lights(idx));

            layout = uigridlayout(parent, [1 2],...
                'Tag', sprintf('%s,%s', az, el));

            sld1 = uislider(layout,...
                'Limits', [0 360],...
                'Value', az,...
                'Tag', num2str(idx),...
                'ValueChangedFcn', @obj.onSliderChangedAzimuth);
            sld2 = uislider(layout,...
                'Limits', [0 360],...
                'Value', el,...
                'Tag', num2str(idx),...
                'ValueChangedFcn', @obj.onSliderChangedElevation);

        end
    end
end