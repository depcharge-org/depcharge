classdef DependencyHandler
    properties
        name
        package
        type
        version
        path
    end
    
    methods
        function obj = DependencyHandler(dependencyInfo)
            obj.name = dependencyInfo.name;
            obj.package = dependencyInfo.package;
            obj.type = dependencyInfo.type;
            obj.version = dependencyInfo.version;
            obj.path = dependencyInfo.path;
        end
        
        function version = getVersion(obj)
            version = obj.version;
        end
        
        function path = getProjectRoot(obj)
            path = obj.path;
        end
        
        function found = isOnPath(obj)
            if ~isempty(obj.package)
                found = ~isempty(which([obj.package '.']));
            else
                % Default behavior if no package is specified
                found = ~isempty(which(obj.name));
            end
        end
        
        function executeAfterDownload(obj)
            % Default empty implementation
        end
        
        function executeBeforeUse(obj)
            % Default empty implementation
        end
        
        function cleanUp(obj)
            % Default empty implementation
        end
    end
end
