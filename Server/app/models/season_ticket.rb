class SeasonTicket < ActiveRecord::Base
  
  belongs_to :organization
  belongs_to :user
  
  delegate :name, to: :user
  delegate :last_four, to: :user
  delegate :email, to: :user
  delegate :reserved_productions, to: :user
  delegate :reserved_performances, to: :user
  
  has_and_belongs_to_many :seats

  before_destroy { seats.clear }
  before_destroy do
    transactions = {}
    tickets.each do |ticket|
      transactions[ticket.transaction.id] = ticket.transaction
    end
    transactions.each do |k,v|
      v.destroy
    end
  end
  
  validate :only_one_season_ticket_per_seat
  
  def self.to_csv
    CSV.generate do |csv|
      total_column_names = column_names + ["name", "seats", "street_address", "city", "state" ]
      csv << total_column_names
      all.each do |ticket|
        seat_ids = Array.new
        ticket.seats.each do |seat|
          seat_ids << seat.id
        end
        user = ticket.user
        csv << ticket.attributes.values_at(*column_names) + [user.name, seat_ids, user.street_address, user.city, user.state]
      end
    end
  end
  
  def tickets
    self.user.tickets.find_all{|t| t.organization.id== self.organization.id}
  end
  
  def self.import(file)
    CSV.foreach(file.path, headers: true) do  |row|
      hash = row.to_hash
      ticket_hash = hash
      ticket_hash.delete("created_at")
      ticket_hash.delete("updated_at")
      ActiveRecord::Base.transaction do
        unless season_ticket = SeasonTicket.find_by_id(ticket_hash["id"])
          new_hash = ticket_hash.except("name", "seats", "street_address", "city", "state")
          season_ticket = SeasonTicket.create!( new_hash )
        end
        if user = User.find_by_id(ticket_hash["user_id"])
          seat_ids = ticket_hash["seats"]
          seat_ids = seat_ids.gsub(/[\[\] ]/, '').split(',')
          user_tickets = user.tickets.find_all{|t| t.organization.id == season_ticket.organization.id }
          user_tickets.each do |t|
            t.destroy
          end
          
          season_ticket.seats.each do |seat|
            season_ticket.seats.delete(seat)
          end
          seat_ids.each do |id|
            seat = Seat.find_by_id(id)
            season_ticket.seats << seat
          end
          
        else
          raise ActiveRecord::Rollback
          raise "no user error"
        end
      end
    end

  end
  
  def only_one_season_ticket_per_seat
    @season_ticket_seat_list = Array.new
    Organization.find_by_id(organization).season_tickets.each do |season_ticket|
      season_ticket.seats.each do |seat|
        if seats.include?(seat)
          errors.add(:seats, "have already been taken")
          return false 
        end
      end
    end
    return true
  end
end
