function manage_dependencies(config, depsPath)
    % manage_dependencies.m
    % Clones or updates dependencies based on the configuration
    %
    % Input:
    %   config: Struct containing the parsed deplist.json content
    %   depsPath: Path to the _deps directory

    for i = 1:length(config.dependencies)
        dep = config.dependencies{i};
        depPath = fullfile(depsPath, dep.name);
        
        switch dep.type
            case 'git'
                manage_git_dependency(dep, depPath);
            case 'path'
                manage_path_dependency(dep, depPath);
            case 'zip'
                manage_zip_dependency(dep, depPath);
            otherwise
                warning('depcharge:manageDependencies:UnknownType', ...
                        'Unknown dependency type: %s', dep.type);
        end
    end
end

function manage_git_dependency(dep, depPath)
    if ~exist(depPath, 'dir')
        % Clone the repository
        cmd = sprintf('git clone %s %s', dep.url, depPath);
        system(cmd);
    end

    % Change to the dependency directory
    oldPath = cd(depPath);

    % Checkout the specified version or branch
    if isfield(dep, 'version')
        if startsWith(dep.version, 'tag:')
            tag = extractAfter(dep.version, 'tag:');
            system(sprintf('git checkout %s', tag));
        elseif startsWith(dep.version, 'branch:')
            branch = extractAfter(dep.version, 'branch:');
            system(sprintf('git checkout %s', branch));
            system('git pull');
        else
            system(sprintf('git checkout %s', dep.version));
        end
    else
        % If no version specified, pull the latest from the current branch
        system('git pull');
    end

    % Change back to the original directory
    cd(oldPath);
end

function manage_path_dependency(dep, depPath)
    if ~exist(dep.path, 'dir')
        error('depcharge:managePathDependency:PathNotFound', ...
              'Specified path for dependency %s does not exist: %s', dep.name, dep.path);
    end
    
    % For path dependencies, we just need to ensure the path is added to MATLAB's path
    addpath(dep.path);
end

function manage_zip_dependency(dep, depPath)
    if ~exist(depPath, 'dir')
        % Download and extract the zip file
        zipFile = fullfile(tempdir, [dep.name '.zip']);
        websave(zipFile, dep.url);
        unzip(zipFile, depPath);
        delete(zipFile);
    end
end