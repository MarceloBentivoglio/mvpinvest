puts "Creating Eu Entrego..........."

euentrego = Seller.create!(
  full_name: "douglas aguiar de carvalho",
  cpf: "04790888967",
  rf_full_name: "douglas aguiar de carvalho",
  rf_sit_cad: "regular",
  birth_date: "11021990",
  mobile: "48984026098",
  company_name: "eu entrego sistemas ltda",
  company_nickname: "eu entrego",
  cnpj: "23859513000158",
  phone: "11984670021",
  website: "www.euentrego.com.br",
  address: "rua marina ciufuli zanfelice",
  address_number: "260",
  address_comp: "",
  neighborhood: "lapa",
  state: "sp",
  city: "são paulo",
  zip_code: "05040000",
  inscr_est: "",
  inscr_mun: "",
  nire: "",
  company_type: "ltda",
  operation_limit_cents: 20000000,
  operation_limit_currency: "BRL",
  fator: 0.049,
  advalorem: 0.001,
  monthly_revenue_cents: 40000000,
  monthly_revenue_currency: "BRL",
  monthly_fixed_cost_cents: 8200000,
  monthly_fixed_cost_currency: "BRL",
  monthly_units_sold: 30000,
  cost_per_unit_cents: 950,
  cost_per_unit_currency: "BRL",
  debt_cents: 0,
  debt_currency: "BRL",
  full_name_partner: "douglas aguiar de carvalho",
  cpf_partner: "04790888967",
  rf_full_name_partner: "douglas aguiar de carvalho",
  rf_sit_cad_partner: "regular",
  birth_date_partner: "11021990",
  mobile_partner: "48984026098",
  email_partner: "financeiro@euentrego.com",
  consent: true,
  validation_status: "active",
  visited: true,
  analysis_status: "approved",
  rejection_motive: "rejection_motive_non_applicable",
  protection: 0.2,
)

euentrego_user = User.create!(
  email: "financeiro@euentrego.com",
  password: "euentrego",
  admin: false,
  seller: euentrego,
)
