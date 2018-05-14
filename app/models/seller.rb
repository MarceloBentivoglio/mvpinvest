class Seller < ApplicationRecord
  PURPOSE = ["product_manufacture", "service_provision", "product_reselling"]

  # validates :company_name, presence: true
  # validates :full_name, presence: true
  # validates :cpf, presence: true
  # validates :cnpj, presence: true
  has_many :users


  # We need this to upload the invoices in xml format and the cheques in pdf
  # has_attached_file :invoice_document
end