module Formatter
    class Base
        def format
            raise
        end
    end

    class Backward < Base
        def initialize(patterns, slice_regexp = nil)
            @patterns = patterns
            @slice_regexp = slice_regexp
        end

        def format(rows)
            current, total = 0, rows.count
            rows.select{|row|
                print("#{current+=1}/#{total}\r")
                base_value = prepare_base_value(row[0])
                @patterns.to_set.include?(base_value) == false
            }
        end

        def prepare_base_value(value)
            value.slice(%r(#{@slice_regexp})) if @slice_regexp
        end
    end

    class Desc < Base
        def initialize(field)
            @field = field
        end

        def format(rows)
            rows.sort_by {|row| row[@field.to_i]}.reverse
        end
    end

    class Asc < Base
        def initialize(field)
            @field = field
        end

        def format(rows)
            rows.sort_by {|row| row[@field.to_i]}
        end
    end
end
