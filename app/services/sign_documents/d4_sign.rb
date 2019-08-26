class D4Sign
  TOKEN = "live_873f0e5da2cb8ba8f993f0ce1c3c4fca17ffa5fa2f1644f3b812bd76abb2909d"
  KEY = "live_crypt_AmmeB26r0NfNAbKlE8NcPGbQtQ3fFhkL"
  SAFEID = "adbc7b6b-3e97-454c-a077-fd4e584d7c30"

  SANDTOKEN = "live_7c63cbb707a96ba089cda6e3b644aca65b4dd8022fb21e2dbd1fca38c712f755"
  SANDKEY = "live_crypt_kddjpziErY8uARLlOhjfLy6wPI8yVlTJ"
  SANDSAFEID = "6fa8946f-d61b-47ae-ad05-465e6897158d"

  def self.upload_document
    url = "http://demo.d4sign.com.br/api/v1/documents/#{D4Sign::SANDSAFEID}/upload?tokenAPI=#{D4Sign::SANDTOKEN}&cryptKey=#{D4Sign::SANDKEY}"
    #url = "https://secure.d4sign.com.br/api/v1/documents/#{D4Sign::SAFEID}/upload?tokenAPI=#{D4Sign::TOKEN}&cryptKey=#{D4Sign::KEY}"
    headers = {
      "Content-Type": "multipart/form-data;",
      "tokenAPI": "#{D4Sign::TOKEN}"
    }
    body = {
      "file": File.new("/home/furuchooo/Downloads/venc_2019_05_09.pdf", "rb"),
    }
    response = RestClient.post(url, body, headers)
    puts response
  end

  def self.add_signer_list
    demo_doc_id = "d9f1a304-350b-4f00-b1d9-f6649e592dec"
    url = "http://demo.d4sign.com.br/api/v1/documents/#{demo_doc_id}/createlist?tokenAPI=#{D4Sign::SANDTOKEN}&cryptKey=#{D4Sign::SANDKEY}"
    #doc_id = "dc0eb955-a532-4bda-b637-0037154526c2"
    #url = "https://secure.d4sign.com.br/api/v1/documents/#{doc_id}/createlist?tokenAPI=#{D4Sign::TOKEN}&cryptKey=#{D4Sign::KEY}"
    headers = {
      "Content-Type": "application/json"
    }

    body = {
      "signers": [
        {
          "email": "furucho@banfox.com.br",
          "act": "1",
          "foreign": "0",
          "certificadoicpbr": "0",
          "assinatura_presencial": "0"
        }
      ]
    }
    response = RestClient.post(url, body, headers)
    puts response.body
    byebug
  end

  def self.get_safes
    url = "http://demo.d4sign.com.br/api/v1/safes?tokenAPI=#{D4Sign::SANDTOKEN}&cryptKey=#{D4Sign::SANDKEY}"
    #url = "https://secure.d4sign.com.br/api/v1/safes?tokenAPI=#{D4Sign::TOKEN}&cryptKey=#{D4Sign::KEY}"
    response = RestClient.get(url)
    return JSON.parse(response)
  end
end
