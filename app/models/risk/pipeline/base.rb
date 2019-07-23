module Risk
  module Pipeline
    class Base
      attr_accessor :key_indicator_report, :evidences

      def initialize(key_indicator_report)
        @key_indicator_report = key_indicator_report
        @evidences = @key_indicator_report.evidences
      end

      class << self
        attr_reader :params, :fetchers, :referees

        def required_params(*params)
          @params = params
        end

        def fetch_from(*fetchers)
          @fetchers = fetchers
        end

        def run_referees(*referees)
          @referees = referees
        end
      end

      
      def valid_input_data?
        self.class.params.reduce(false)  do |valid, key|
          @key_indicator_report.input_data.has_key?(key.to_s)
        end
      end

      def require_fetcher?
        self.class.fetchers.any?
      end

      def call
        self.class.referees.each do |referee_klass|
          referee = referee_klass.new(@evidences)
          key_indicator_report.key_indicators[referee.code] = {
            title: referee.title,
            description: referee.description,
            flag: referee.call
          }
        end
      end

    end
  end
end
