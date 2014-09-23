module TransactionsHelper

  def clear_old_transactions
    old_transactions = Transaction.all.where('created_at < :five_minutes_ago AND pending = true', :five_minutes_ago => 5.minutes.ago)
    old_transactions.each do |transaction|
      transaction.destroy
    end
  end
end
