module ApplicationHelper
	def	date_hash_to_date(hash)
		Date.today.change(hash.each{|k,v| hash.store(k,v.to_i)})
	end
	
	def time_hash_to_time(hash)
		minute=hash.fetch("minute")
		hash.store("min", minute)
		hash.delete("minute")
    value = hash.each{|k,v| hash.store(k,v.to_i)}
    time = Time.zone.now.change(hour: hash["hour"], min: hash["min"])
    time = Time.zone.local_to_utc(time)
    return time
	end
  
  def time_hash
    {"year"=>2000, "month"=>1, "day"=>1, "hour"=>17, "minute"=>0}
  end
  
  def flash_class(level)
    case level
        when :notice then "alert alert-info"
        when :success then "alert alert-success"
        when :error then "alert alert-danger"
        when :alert then "alert alert-warning"
    end
  end
  
  def setup_errors(model)
    error_message = ""
    model.errors.full_messages.each do |msg|
      error_message << "<p>#{msg}</p>"
    end
    flash[:error] = error_message.html_safe
  end
  
  def no_access_error
    flash[:error] = "You don't have access to this page"
  end
  
  def transaction_timed_out
    flash[:error] = "Transaction timed out. Please Try again"
  end
  
  def datepicker_format(date)
    date.strftime("%m/%d/%Y")
  end
  
  def formatted_time(time)
    time.strftime("%l:%M %P")
  end
          
  def formatted_price(price)
    if price
      return "%.2f" % price
    end
    return nil
      
  end
  
  def authenticate_admin(organization=nil, supervisor_code=nil)
    unless @current_user.administrator?(organization) || organization.has_supervisor?(supervisor_code.to_i)
      no_access_error
      redirect_to root_path
      return false
    end
    return true
  end
end
