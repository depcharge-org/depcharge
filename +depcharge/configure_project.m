function configure_project()
    % configure_project.m
    % Configures the project by determining the project root directory and package name.
    % Verifies that the top level package name isn't "depcharge" to avoid name conflicts.
    % Manages project dependencies based on deplist.json.

    % Get the caller context
    context = depcharge.get_caller_context(2);

    % Print the results
    fprintf('Package names: %s\n', strjoin(context.packageNames, ', '));
    fprintf('Root path: %s\n', context.rootPath);
    fprintf('Full file path: %s\n', context.callingFile);

    % Verify that the top level package name isn't "depcharge"
    if context.packageNames(1) == "depcharge"
        error('depcharge:configureProject:InvalidPackageName', ...
              'The top level package name cannot be "depcharge" as it would create name conflicts.');
    end

    % Parse the deplist.json file
    configPath = fullfile(context.rootPath,sprintf("+%s/",context.packageNames));
    config = depcharge.parse_deplist(configPath);

    % Create _deps directory if it doesn't exist
    depsPath = fullfile(context.rootPath, '_deps');
    if ~exist(depsPath, 'dir')
        mkdir(depsPath);
    end

    % Manage dependencies
    depcharge.manage_dependencies(config, depsPath);

    fprintf('Project configuration and dependency management completed.\n');
end