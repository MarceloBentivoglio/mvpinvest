module Risk
  module Decorator
    class Serasa
      attr_accessor :evidences

      def initialize(evidences = {})
        @evidences = evidences.with_indifferent_access
      end

      def partner_cpf
        @evidences[:cpf]
      end

      def partner_name
        @evidences[:name]
      end

      def partner_documents
        documents = @evidences[:partner_documents]&.map do |partner_document|
          Risk::Decorator::Serasa.new(partner_document)
        end

        documents || []
      end

      def partner_entry_date
        begin
          Date.parse(@evidences[:entry_date])
        rescue
          nil
        end
      end

      def partner_name
        @evidences[:name]
      end

      def partner_pf_or_pj
        @evidences[:pf_or_pj]
      end

      def partner_cpf_or_cnpj
        @evidences[:cpf_or_cnpj]
      end

      def social_capital
        @evidences.dig(:company_data, :social_capital)
      end

      def founded_in
        begin
          Date.parse(@evidences.dig(:company_data, :founded_in))
        rescue
          nil
        end
      end

      def injuction
        @evidences.dig(:company_data, :injuction)
      end

      def refin_value
        @evidences.dig(:refin)&.first&.dig(:value) || 0
      end

      def refin_historic_value
        if @evidences.dig(:historic)&.any?
          @evidences.dig(:historic)&.first&.dig(:refin)&.first&.dig(:value) || 0
        else
          nil
        end
      end

      def refin_quantity
        @evidences&.dig(:refin)&.first&.dig(:quantity) || 0
      end

      def refin_historic_quantity
        if @evidences.dig(:historic)&.any?
          @evidences.dig(:historic)&.first&.dig(:refin)&.first&.dig(:quantity) || 0
        else
          nil
        end
      end

      def lawsuit_quantity
        @evidences&.dig(:lawsuit)&.first&.dig(:quantity) || 0
      end

      def lawsuit_historic_quantity
        if @evidences.dig(:historic).any?
          @evidences.dig(:historic)&.first&.dig(:lawsuit)&.first&.dig(:quantity) || 0
        else
          nil
        end
      end

      def lawsuit_value
        @evidences&.dig(:lawsuit)&.first&.dig(:value) || 0
      end

      def lawsuit_historic_value
        if @evidences.dig(:historic).any?
          @evidences.dig(:historic)&.first&.dig(:lawsuit)&.first&.dig(:value) || 0
        else
          nil
        end
      end

      def pefin_quantity
        @evidences&.dig(:pefin)&.first&.dig(:quantity) || 0
      end

      def pefin_historic_quantity
        if @evidences.dig(:historic).any?
          @evidences.dig(:historic)&.first&.dig(:pefin)&.first&.dig(:quantity) || 0
        else
          nil
        end
      end

      def pefin_value
        @evidences&.dig(:pefin)&.first&.dig(:value) || 0
      end

      def pefin_historic_value
        if @evidences.dig(:historic).any?
          @evidences.dig(:historic)&.first&.dig(:pefin)&.first&.dig(:value) || 0
        else
          nil
        end
      end

      def protest_quantity
        @evidences&.dig(:protest)&.first&.dig(:quantity) || 0
      end

      def protest_historic_quantity
        if @evidences.dig(:historic).any?
          @evidences.dig(:historic)&.first&.dig(:protest)&.first&.dig(:quantity) || 0
        else
          nil
        end
      end

      def protest_value
        @evidences&.dig(:protest)&.first&.dig(:value) || 0
      end

      def protest_historic_value
        if @evidences.dig(:historic).any?
          @evidences.dig(:historic)&.first&.dig(:protest)&.first&.dig(:value) || 0
        else
          nil
        end
      end

      def each_cnpj
        @evidences['serasa_api'].keys.each do |cnpj|
          yield cnpj, self.class.new(@evidences['serasa_api'][cnpj]) if cnpj != 'historic'
        end
      end
    end
  end
end
