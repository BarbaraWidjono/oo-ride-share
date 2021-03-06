require_relative 'user'
require 'pry'

module RideShare
  class Driver < User
    attr_reader :vin, :driven_trips, :status

    def initialize(input)
      super

      @vin = input[:vin]
      if @vin.length != 17
        raise ArgumentError.new("Invalid VIN")
      else
        @vin = input[:vin]
      end

      @driven_trips = input[:driven_trips].nil? ? [] : input[:driven_trips]

      if input[:status] != :AVAILABLE && input[:status] != :UNAVAILABLE
        @status = :UNAVAILABLE
      else
        @status = input[:status]
      end
    end

    def add_driven_trip(trip)
      if trip.is_a? Trip
      # binding.pry
        @driven_trips << trip
      # binding.pry
      else
        raise ArgumentError.new("Invalid trip instance")
      end
    end

    def average_rating
      total_num_rides = @driven_trips.length
      total_sum = 0

      if total_num_rides == 0
        return 0
      end

      @driven_trips.each do |x|
        # binding.pry
        if x.rating == "In Progress"
          next
        else
          total_sum += x.rating
        end
      end

      avg_rating = total_sum.to_f / total_num_rides
      return avg_rating

    end


    def total_revenue
     total_cost_all_trips = 0
     total_num_rides = 0

     # if total_num_rides == 0
     #   return 0
     # end

     @driven_trips.each do |x|
       if x.cost == "In Progress"
         next
       else
         total_cost_all_trips += x.cost
         total_num_rides += 1
       end
     end

     all_fees = total_num_rides * 1.65
     driver_revenue = (total_cost_all_trips - all_fees) * 0.8
     driver_revenue_rounded = driver_revenue.round(2)

     return driver_revenue_rounded
    end

    def net_expenditures
     net_expenditures = super
     difference = net_expenditures - total_revenue
     # difference = super - total_revenue # can use super in place of above code.
    return difference
    end

    def change_availability
      if @status == :AVAILABLE
        @status = :UNAVAILABLE
      else
        @status = :AVAILABLE
      end
    end
  end
end
