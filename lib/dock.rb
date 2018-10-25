class Dock
  attr_reader :name,
              :max_rental_time,
              :rented_boats,
              :revenue,
              :charges,
              :total_hours_by_rental_type

  def initialize(name, max_rental_time)
    @name = name
    @max_rental_time = max_rental_time
    @rented_boats = []
    @revenue = 0
    @charges = Hash.new(0)
    @total_hours_by_rental_type = Hash.new(0)
  end

  def rent(boat, renter)
    @rented_boats << boat
    boat.rent(renter)
  end

  def log_hour
    @rented_boats.each do |boat|
      boat.add_hour
    end
  end

  def return(boat)
    @rented_boats.delete_if do
      |rented_boat| rented_boat == boat
    end
    charge(boat)
  end

  def charge(boat)
    if boat.hours_rented > max_rental_time
      time = max_rental_time
    else
      time = boat.hours_rented
    end
    charge = time * boat.price_per_hour
    @revenue += charge
    @charges[boat.renter.credit_card_number] += charge
    @total_hours_by_rental_type[boat.type] += boat.hours_rented
  end
end
