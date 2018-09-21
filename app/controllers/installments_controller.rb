class InstallmentsController < ApplicationController
  before_action :set_seller, only: [:store, :opened, :history]

  def store
    @no_operation_in_analysis        = true
    @operation_analysis_finished     = false
    @operation_completely_approved   = false
    @operation_completely_rejected   = false
    operation = Operation.last_from_seller(@seller)
    @installments = Installment.ordered_in_analysis(@seller).paginate(page: params[:page])
    @no_operation_in_analysis        = false
    if operation && operation.analysis_finished?
      @installments = operation.installments.paginate(page: params[:page])
      @operation_analysis_finished   = true
      @operation_completely_approved = true if operation.completely_approved?
      @operation_completely_rejected = true if operation.completely_rejected?
    elsif @installments.empty?
      @installments = Installment.in_store(@seller).paginate(page: params[:page])
      @no_operation_in_analysis = true
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def opened
    @installments = Installment.currently_opened(@seller).paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def history
    @installments = Installment.finished(@seller).paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @installment = Installment.find(params[:id])
    authorize @installment
    @installment.destroy
    redirect_to store_installments_path
  end

  private

  def set_seller
    @seller = current_user.seller
  end
end
