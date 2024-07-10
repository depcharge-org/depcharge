function config = parse_deplist(configPath)
    % parse_deplist.m
    % Parses the deplist.json file and returns a struct with the configuration
    %
    % Input:
    %   configPath: Path to the project config directory, eg
    %   project_root/+project/+depcharge
    %
    % Output:
    %   config: A struct containing the parsed deplist.json content

    deplistPath = fullfile(configPath, 'deplist.json');
    
    if ~exist(deplistPath, 'file')
        error('depcharge:parseDeplist:FileNotFound', ...
              'deplist.json not found in the project root directory.');
    end

    % Read and parse the JSON file
    fid = fopen(deplistPath, 'r');
    raw = fread(fid, inf);
    str = char(raw');
    fclose(fid);
    
    config = jsondecode(str);

    % Validate the parsed configuration
    required_fields = {'project_name', 'version', 'dependencies'};
    for i = 1:length(required_fields)
        if ~isfield(config, required_fields{i})
            error('depcharge:parseDeplist:MissingField', ...
                  'Required field "%s" is missing in deplist.json', required_fields{i});
        end
    end
end