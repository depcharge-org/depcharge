function [packageNames, rootPath] = parse_package_path(packagePath)
    % Split the path into its components
    pathComponents = strsplit(packagePath, filesep);
    
    % Initialize variables
    packageNames = string.empty;
    rootPath = '';
    
    % Iterate through the components in reverse order
    for i = length(pathComponents):-1:1
        component = pathComponents{i};
        if startsWith(component, '+')
            % If it's a package, add it to the beginning of the array
            packageNames = [strip(component, 'left', '+'), packageNames];
        else
            % If it's not a package, we've found the root
            rootPath = fullfile(pathComponents{1:i});
            break;
        end
    end
    
    % If no non-package folder was found, set rootPath to the full path
    if isempty(rootPath)
        rootPath = packagePath;
    end
end
