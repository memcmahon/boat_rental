require 'minitest/autorun'
require 'minitest/pride'
require './lib/dock'
require './lib/boat'
require './lib/renter'
require 'pry'

class DockTest < Minitest::Test
  def test_it_exists
    dock = Dock.new("The Rowing Dock", 3)

    assert_instance_of Dock, dock
  end

  def test_it_has_attributes
    dock = Dock.new("The Rowing Dock", 3)

    assert_equal "The Rowing Dock", dock.name
    assert_equal 3, dock.max_rental_time
  end

  def test_dock_can_rent_a_boat
     dock = Dock.new("The Rowing Dock", 3)
     kayak_1 = Boat.new(:kayak, 20)
     patrick = Renter.new("Patrick Star", "4242424242424242")
     dock.rent(kayak_1, patrick)

     assert_equal [kayak_1], dock.rented_boats
  end

  def test_it_can_log_hours
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    canoe = Boat.new(:canoe, 25)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")
    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    dock.log_hour
    dock.rent(canoe, patrick)
    dock.log_hour

    assert_equal 2, kayak_1.hours_rented
    assert_equal 2, kayak_2.hours_rented
    assert_equal 1, canoe.hours_rented
  end

  def test_it_can_return_boats
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    canoe = Boat.new(:canoe, 25)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")
    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    dock.rent(canoe, patrick)
    dock.return(kayak_1)

    assert_equal [kayak_2, canoe], dock.rented_boats

    dock.return(kayak_2)
    dock.return(canoe)

    assert_equal [], dock.rented_boats
  end

  def test_it_can_calculate_revenue
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    canoe = Boat.new(:canoe, 25)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")
    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    dock.log_hour
    dock.rent(canoe, patrick)
    dock.log_hour
    dock.return(kayak_1)
    dock.return(kayak_2)
    dock.return(canoe)

    assert_equal 105, dock.revenue
  end

  def test_it_can_account_for_max_rental_time
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    canoe = Boat.new(:canoe, 25)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    sup_2 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")
    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    dock.log_hour
    dock.rent(canoe, patrick)
    dock.log_hour
    dock.return(kayak_1)
    dock.return(kayak_2)
    dock.return(canoe)
    dock.rent(sup_1, eugene)
    dock.rent(sup_2, eugene)
    dock.log_hour
    dock.log_hour
    dock.log_hour
    dock.log_hour
    dock.log_hour
    dock.return(sup_1)
    dock.return(sup_2)

    assert_equal 195, dock.revenue
  end

  def test_it_can_report_on_charges
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    canoe = Boat.new(:canoe, 25)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    sup_2 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")
    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    dock.log_hour
    dock.rent(canoe, patrick)
    dock.log_hour
    dock.return(kayak_1)
    dock.return(kayak_2)
    dock.return(canoe)
    dock.rent(sup_1, eugene)
    dock.rent(sup_2, eugene)
    dock.log_hour
    dock.log_hour
    dock.log_hour
    dock.log_hour
    dock.log_hour
    dock.return(sup_1)
    dock.return(sup_2)

    expected = {"4242424242424242" => 105, "1313131313131313" => 90}
    assert_equal expected, dock.charges
  end

  def test_it_can_report_on_total_hours_by_type
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    canoe = Boat.new(:canoe, 25)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    sup_2 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")
    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    dock.log_hour
    dock.rent(canoe, patrick)
    dock.log_hour
    dock.return(kayak_1)
    dock.return(kayak_2)
    dock.return(canoe)
    dock.rent(sup_1, eugene)
    dock.rent(sup_2, eugene)
    dock.log_hour
    dock.log_hour
    dock.log_hour
    dock.log_hour
    dock.log_hour
    dock.return(sup_1)
    dock.return(sup_2)

    expected = {:kayak => 4, :canoe => 1, :standup_paddle_board => 10}

    assert_equal expected, dock.total_hours_by_rental_type
  end


end

# dock = Dock.new("The Rowing Dock", 3)
# kayak_1 = Boat.new(:kayak, 20)
# kayak_2 = Boat.new(:kayak, 20)
# canoe = Boat.new(:canoe, 25)
# sup_1 = Boat.new(:standup_paddle_board, 15)
# sup_2 = Boat.new(:standup_paddle_board, 15)
# patrick = Renter.new("Patrick Star", "4242424242424242")
# eugene = Renter.new("Eugene Crabs", "1313131313131313")
# dock.rent(kayak_1, patrick)
 # require './lib/renter'
#
# pry(main)> require './lib/boat'
#
# pry(main)> require './lib/dock'
#
# pry(main)> dock = Dock.new("The Rowing Dock", 3)
#
# pry(main)> kayak_1 = Boat.new(:kayak, 20)
#
# pry(main)> kayak_2 = Boat.new(:kayak, 20)
#
# pry(main)> canoe = Boat.new(:canoe, 25)
#
# pry(main)> sup_1 = Boat.new(:standup_paddle_board, 15)
#
# pry(main)> sup_2 = Boat.new(:standup_paddle_board, 15)
#
# pry(main)> patrick = Renter.new("Patrick Star", "4242424242424242")
#
# pry(main)> eugene = Renter.new("Eugene Crabs", "1313131313131313")
#
# # Rent Boats out to first Renter
# pry(main)> dock.rent(kayak_1, patrick)
#
# pry(main)> dock.rent(kayak_2, patrick)
#
# pry(main)> dock.log_hour
#
# pry(main)> dock.rent(canoe, patrick)
#
# pry(main)> dock.log_hour
#
# pry(main)> dock.return(kayak_1)
#
# pry(main)> dock.return(kayak_2)
#
# pry(main)> dock.return(canoe)
#
# # Revenue thus far
# pry(main)> dock.revenue
# #=> 105
#
# # Rent Boats out to second Renter
# pry(main)> dock.rent(sup_1, eugene)
#
# pry(main)> dock.rent(sup_2, eugene)
#
# pry(main)> dock.log_hour
#
# pry(main)> dock.log_hour
#
# pry(main)> dock.log_hour
#
# # Any hours rented past the max rental time are not counted
# pry(main)> dock.log_hour
#
# pry(main)> dock.log_hour
#
# pry(main)> dock.return(sup_1)
#
# pry(main)> dock.return(sup_2)
#
# # Total revenue
# pry(main)> dock.revenue
# #=> 195
