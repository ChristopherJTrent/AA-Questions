class DatabaseObject
    def initialize(options)
        options.each do |k, v|
            instance_variable_set("@#{k}", v) unless v.nil?
        end
    end
end