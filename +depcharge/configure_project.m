% +depcharge/configure_project.m
% Intended to be called from within a user's project, eg
% /project_name/+project_name/+depcharge/update.m
% Configures the project by first programatically determining 
% The project root directory and package name.
% Also verify that the top level package name isn't "depcharge", which
% would create name conflicts.
function configure_project()
    % Get the full path of the calling function
    st = dbstack('-completenames');
    if length(st) > 1
        callingFile = st(2).file;
        [callingPath, ~, ~] = fileparts(callingFile);
        
        % Parse the package path
        [packageNames, rootPath] = depcharge.parse_package_path(callingPath);
        
        % Print the results
        fprintf('Package names: %s\n', strjoin(packageNames, ', '));
        fprintf('Root path: %s\n', rootPath);
        fprintf('Full file path: %s\n', callingFile);
    else
        fprintf('This function was called from the command window.\n');
    end
end
