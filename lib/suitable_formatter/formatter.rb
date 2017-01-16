module Formatter
    class Base
        def format
            raise
        end
    end

    class Backward < Base
        def initialize(patterns)
            @patterns = patterns
        end

        def format(rows)
            rows.select{|row|
                nil == row[0].match(/(#{@patterns.join('|')})$/)
            }
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
end
