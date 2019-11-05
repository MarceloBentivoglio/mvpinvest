class BillingRulerService

  def initialize(sellers)
    @sellers = sellers
  end

  def send_mails
    today = Date.today
    installments = []
    month_installments = []
    week_installments = []
    due_date_installments = []
    just_overdued_installments = []
    overdue_installments = []
    overdue_pre_serasa_installments = []
    sending_to_serasa_installments = []
    overdue_after_serasa_installments = []
    protest_installments = []
    no_installments = true
    @sellers.each do |seller|
      if today == today.beginning_of_month
        SlackMessage.new("CPVKLBR3J", "<!channel> Enviados e-mails de Organização Mensal").send_now
        seller.invoices.each do |invoice|
          invoice.installments.each do |installment|
            month_installments << installment if installment.opened? && installment.due_date.month == Date.today.month
          end
        end
        SellerMailer.monthly_organization(seller.users.first, seller, month_installments).deliver_now
      elsif today == today.beginning_of_week && today.day > 3
        SlackMessage.new("CPVKLBR3J", "<!channel> Enviados e-mails de Organização Semanal").send_now
        seller.invoices.each do |invoice|
          invoice.installments.each do |installment|
            week_installments << installment if installment.opened? && installment.due_date.between?(Date.today.beginning_of_week, Date.today.end_of_week)
          end
        end
        SellerMailer.weekly_organization(seller.users.first, seller, week_installments).deliver_now
      end

      seller.invoices.each do |invoice|
        invoice.installments.each do |installment|
          installments << installment if installment.opened? && installment.due_date <= today
        end
      end

      installments.each do |installment|
        case today - installment.due_date
        when 0..2
          due_date_installments << installment
          no_installments = false
        when 3
          just_overdued_installments << installment
          no_installments = false
        when 4..8
          overdue_installments << installment
          no_installments = false
        when 9..18
          overdue_pre_serasa_installments << installment
          no_installments = false
        when 19
          sending_to_serasa_installments << installment
          no_installments = false
        when 22..28
          overdue_after_serasa_installments << installment
          no_installments = false
        when 29
          protest_installments << installment
          no_installments = false
        end
      end

      billing_ruler_mails("due_date", due_date_installments, seller) unless due_date_installments.empty?
      billing_ruler_mails("just_overdued", just_overdued_installments, seller) unless just_overdued_installments.empty?
      billing_ruler_mails("overdue", overdue_installments, seller) unless overdue_installments.empty?
      billing_ruler_mails("overdue_pre_serasa", overdue_pre_serasa_installments, seller) unless overdue_pre_serasa_installments.empty?
      billing_ruler_mails("sending_to_serasa", sending_to_serasa_installments, seller) unless sending_to_serasa_installments.empty?
      billing_ruler_mails("overdue_after_serasa", overdue_after_serasa_installments, seller) unless overdue_after_serasa_installments.empty?
      billing_ruler_mails("protest", protest_installments, seller) unless protest_installments.empty?
    end

    if no_installments
      SlackMessage.new("CPVKLBR3J", "<!channel> Nenhum e-mail foi enviado hoje.").send_now
    end
  end

  private

  def billing_ruler_mails(method, installments, seller)
    billing_ruler = BillingRuler.new
    billing_ruler.seller = seller
    installments.each do |i|
      billing_ruler.installments << i
    end
    billing_ruler.code = SecureRandom.uuid
    billing_ruler.send(method + "!")
    billing_ruler.send_to_seller!
    installments_text = ""
    installments.each do |i|
      installments_text += "#{i.invoice.number}/#{i.number} \n "
    end
    SellerMailer.send(method, @seller.users.first, @seller, installments, installments_text, billing_ruler.code).deliver_now
  end
end
