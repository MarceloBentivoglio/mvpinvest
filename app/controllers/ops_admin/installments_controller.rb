class OpsAdmin::InstallmentsController < OpsAdmin::BaseController
  before_action :set_installment, only: [:approve, :reject, :deposit, :report_paid, :report_pdd]
  before_action :set_seller, only: [:approve, :reject, :deposit, :report_paid, :report_pdd]

  #TODO refactor all thesses method and put them on service
  def approve
    # TODO: This values should be in fact inputs from the ops_admin/operations so that the admin can customize the operation
    @installment.initial_fator = @installment.fator
    @installment.initial_advalorem = @installment.advalorem
    @installment.initial_protection = @installment.protection
    @installment.veredict_at = Time.current
    @installment.approved!
    @installment.operation.notify_seller(@seller)
    redirect_to ops_admin_operations_analyse_path
  end

  def reject
    @installment.initial_fator = @installment.fator
    @installment.initial_advalorem = @installment.advalorem
    @installment.initial_protection = @installment.protection
    @installment.veredict_at = Time.current
    @installment.rejected!
    @installment.payer_low_rated!
    @installment.operation.notify_seller(@seller)
    redirect_to ops_admin_operations_analyse_path
  end

  def deposit
    operation = @installment.operation
    @installment.deposited_at = Time.current
    @installment.deposited!
    operation.credit = @seller.payment_credits.sum(:credit) if operation.credit.nil?
    payment_credit = PaymentCredit.new.tap do |pc|
      pc.installment_id = @installment.id
      pc.seller_id = @installment.invoice.seller_id
      pc.paid_date = @installment.finished_at
      pc.credit = operation.credit * -1
    end
    payment_credit.save!
    @installment.opened!
    @installment.operation.notify_seller(@seller)
    operation.save
    redirect_to ops_admin_operations_deposit_path
  rescue Exception => e
    Rollbar.error(e)
    payment_credit.destroy unless payment_credit.nil?
    redirect_to ops_admin_operations_deposit_path
  end

  def report_paid
    @installment.final_fator = @installment.fator
    @installment.final_advalorem = @installment.advalorem
    @installment.final_protection = @installment.protection
    @installment.finished_at = Time.current
    payment_credit = PaymentCredit.new.tap do |pc|
      pc.installment_id = @installment.id
      pc.seller_id = @installment.invoice.seller_id
      pc.paid_date = @installment.finished_at
      pc.credit = @installment.delta_fee
    end
    payment_credit.save
    @installment.paid!
    @installment.notify_seller(@seller)
    redirect_to ops_admin_operations_follow_up_path
  rescue Exception => e
    Rollbar.error(e)
    payment_credit.destroy
    redirect_back(fallback_location: ops_admin_operations_follow_up_path)
  end

  def report_pdd
    @installment.final_fator = @installment.fator
    @installment.final_advalorem = @installment.advalorem
    @installment.final_protection = @installment.protection
    @installment.finished_at = Time.current
    @installment.pdd!
    redirect_to  ops_admin_operations_follow_up_path
  end

  private

  def set_installment
    @installment = Installment.find(params[:id])
  end

  def set_seller
    @seller = @installment.invoice.seller
  end
end
