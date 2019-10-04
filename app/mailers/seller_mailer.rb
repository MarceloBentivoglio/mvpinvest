class SellerMailer < ApplicationMailer
  default from: 'marcelo@banfox.com.br'

  def welcome(user, seller)
    user = user
    @seller = seller

    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Bem vindo à Banfox'
      )
  end

  def rejected(user, seller)
    user = user
    @seller = seller

    mail(
      to: set_recipients(user.email, @seller.email_partner),
      subject: 'Ainda não conseguimos te ajudar'
      )
  end

  private

  def set_recipients(contact_email, partner_email)
    if contact_email == partner_email
      return contact_email
    else
      return [contact_email, partner_email]
    end
  end
end
