function FV = clipMesh2(FV, varargin)
    % CLIPMESH 
    %
    % Description:
    %   Remove faces and vertices above/below a cutoff point
    %
    % Inputs:
    %   FV      Struct with 'faces' and 'vertices' OR patch handle
    %   cutoff  Cutoff point (microns)
    % Optional inputs:
    %   over    Set true to keep points greater than Z (default = true)
    %   dim     Which dimension: x y or z (default = 3)
    %
    % Outputs:
    %   FV      New struct with 'faces' and 'vertices'
    %           If FV is a patch handle and no output, will apply to patch
    %
    % See also:
    %   CLIPMESHBYSTRATIFICATION, CLIPMESHBYVERTICES
    %
    % History:
    %   09Jan2018 - SSP
    %   28Jan2018 - SSP - Added trimMesh to remove clipped vertices
    %   12Dec2020 - SSP - Added option to cut X or Y dimensions
    % ---------------------------------------------------------------------
    
    
    ip = inputParser();
    addParameter(ip, 'X', [], @(x) isa(x, 'function_handle'));
    addParameter(ip, 'Y', [], @(x) isa(x, 'function_handle'));
    addParameter(ip, 'Z', [], @(x) isa(x, 'function_handle'));
    parse(ip, varargin{:});

    xFcn = ip.Results.X;
    yFcn = ip.Results.Y;
    zFcn = ip.Results.Z;
    
    renderNow = false;
    if isa(FV, 'matlab.graphics.primitive.Patch')
        p = FV;
        FV = struct(...
            'faces', get(p, 'Faces'),...
            'vertices', get(p, 'Vertices'));
        if nargout == 0
            % Change the render to match output
            renderNow = true;
        end
    end
    
    verts = FV.vertices;
    faces = FV.faces;
    
    % Get the indices of vertices to be clipped out
    idx = true(size(verts, 1), 1);
    if ~isempty(xFcn)
        idx = idx & xFcn(verts(:, 1));
    end
    if ~isempty(yFcn)
        idx = idx & yFcn(verts(:,2));
    end
    if ~isempty(zFcn)
        idx = idx & zFcn(verts(:, 3));
    end
    cutVerts = find(idx);
    fprintf('Clipping out %u of %u vertices\n', nnz(idx), numel(idx));
    
    % Find which faces contain one or more clipped vertices
    cutFacesIdx = [];
    for i = 1:size(faces,1)
        if ~isempty(intersect(faces(i,:), cutVerts))
            cutFacesIdx = [cutFacesIdx, i]; %#ok
        end
    end

    % Remove the faces with vertices over/under the cutoff point
    FV.faces(cutFacesIdx, :) = [];
    % Trim out the unused vertices
    [FV.vertices, FV.faces] = trimMesh(FV.vertices, FV.faces);
    
    if renderNow
        set(p, 'Faces', FV.faces, 'Vertices', FV.vertices);
    end