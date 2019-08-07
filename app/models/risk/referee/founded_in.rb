module Risk
  module Referee
    class FoundedIn < Base
      def initialize(evidence)
        @evidence = {
          founded_in: evidence.founded_in
        }
        @code = 'founded_in'
        @title = 'Founded In'
        @description = repr_date(@evidence[:founded_in])
        @params = {
          yellow_limit: 3,
          red_limit: 2
        }
      end

      def assert
        if @evidence[:founded_in].nil?
          Risk::KeyIndicatorReport::GRAY_FLAG
        else
          year_diff = (Date.today - @evidence[:founded_in])/365
         
          if year_diff <= @params[:red_limit]
            Risk::KeyIndicatorReport::RED_FLAG
          elsif year_diff  <= @params[:yellow_limit]
            Risk::KeyIndicatorReport::YELLOW_FLAG
          else
            Risk::KeyIndicatorReport::GREEN_FLAG
          end
        end
      end
    end
  end
end
