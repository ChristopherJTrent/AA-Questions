require 'activesupport/inflector'

class DatabaseObject
    def initialize(options)
        options.each do |k, v|
            instance_variable_set("@#{k}", v) unless v.nil?
            self.class.send(:attr_accessor, k.to_s)
        end
    end

    def save
        unless id
            insert_segment = "#{tableize(self.class.name)} (#{instance_variables.join(", ")})"
            instance_vars = instance_variables.map { |var| instance_variable_get(var) } #values of each instance variable 
            values_segment = "(#{instance_vars.join(", ")})"
            DBConnector.instance.execute(<<-SQL)
                INSERT INTO #{insert_segment}
                VALUES #{values_segment}
            SQL
            @id = DBConnector.instance.last_insert_row_id
        else
            instance_vars = instance_variables.map { |var| "#{var.to_s} = #{instance_variable_get(var)}" }
            DBConnector.instance.execute(<<-SQL, id)
                UPDATE #{tableize(self.class.name)}
                SET #{instance_vars.join(", ")}
                WHERE id = ?
            SQL
        end
    end
end