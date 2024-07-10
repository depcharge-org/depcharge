function context = get_caller_context(depth)
    % get_caller_context.m
    % Returns a struct containing information about the calling context
    %
    % Input:
    %   depth (optional): How far up the call stack to look. Default is 1.
    %
    % Output:
    %   context: A struct with fields:
    %     - packageNames: String array of package names
    %     - rootPath: Path to the folder containing the top level package
    %     - callingFile: Full path to the calling file

    if nargin < 1
        depth = 1;
    end

    st = dbstack('-completenames');
    if length(st) > depth
        callingFile = st(depth + 1).file;
        [callingPath, ~, ~] = fileparts(callingFile);
        
        % Parse the package path
        [packageNames, rootPath] = depcharge.parse_package_path(callingPath);
        
        % Create the context struct
        context = struct('packageNames', packageNames, ...
                         'rootPath', rootPath, ...
                         'callingFile', callingFile);
    else
        error('depcharge:getCallerContext:InvalidDepth', ...
              'The specified depth exceeds the call stack depth.');
    end
end