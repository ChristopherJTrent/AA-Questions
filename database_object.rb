class DatabaseObject
    def initialize(options)
        options.each do |k, v|
            instance_variable_set("@#{k}", v) unless v.nil?
            self.class.send(:attr_accessor, k.to_s)
        end
    end
end