module CreditAnalysis
  module CPFInformationFetch
    class BigBoostCpfInfo
      attr_reader :treated_cpf_info

      def initialize(cpf)
        @cpf = cpf
        fetch_information
        @treated_cpf_info = treat_cpf_info
      end

      private

      def url
        Rails.application.credentials[Rails.env.to_sym][:nogord][:cpf_info_fetch_url]
      end

      def headers
        { Content_Type: "application/json", Authorization: Rails.application.credentials[:nogord][:token] }
      end

      def body
        { cpf: @cpf }.to_json
      end

      def fetch_information
        cpf_info_serialized = RestClient.post(url, body, headers)
        @cpf_info = JSON.parse(cpf_info_serialized).deep_symbolize_keys
      end

      def treat_cpf_info
        #TODO Use & to protect the code against schema changes
        {
          name: @cpf_info[:info][:external_sources][0][:data][:Result][:BasicData][:Name].downcase,
          taxIdStatus: @cpf_info[:info][:external_sources][0][:data][:Result][:BasicData][:TaxIdStatus].downcase
        }
      end
    end
  end
end
