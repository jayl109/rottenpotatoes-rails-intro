class Movie < ActiveRecord::Base
    class << self
        def ratings
     
            return ["G", "PG", "PG-13", "R"]
        end
    end
end
