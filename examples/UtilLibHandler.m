classdef UtilLibHandler < DependencyHandler
    methods
        function version = getVersion(obj)
            % Custom version retrieval for UtilityLibrary
            versionFile = fullfile(obj.getProjectRoot(), 'VERSION');
            if exist(versionFile, 'file')
                fid = fopen(versionFile, 'r');
                version = fgetl(fid);
                fclose(fid);
            else
                version = obj.version;
            end
        end
        
        function executeAfterDownload(obj)
            % Custom post-download actions for UtilityLibrary
            fprintf('Running post-download setup for UtilityLibrary...\n');
            run(fullfile(obj.getProjectRoot(), 'setup.m'));
        end
        
        function found = isOnPath(obj)
            % Custom path check for UtilityLibrary
            found = ~isempty(which('utillib.core.initialize'));
        end
    end
end
