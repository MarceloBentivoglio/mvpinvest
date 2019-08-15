class OperationMailerPreview < ActionMailer::Preview
  def approved
    OperationMailer.approved(Operation.first, User.first, Seller.first).deliver_now
  end

  def deposited
    OperationMailer.deposited(Operation.first, User.first, Seller.first).deliver_now
  end

  def partially_approved
    OperationMailer.partially_approved(Operation.first, User.first, Seller.first).deliver_now
  end

  def rejected
    OperationMailer.rejected(Operation.first, User.first, Seller.first).deliver_now
  end

  def to_analysis
    OperationMailer.to_analysis(Operation.first, User.first, Seller.first).deliver_now
  end

end
