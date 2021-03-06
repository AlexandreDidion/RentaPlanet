class BookingsController < ApplicationController
  before_action :set_planet, only: [:new, :create]
  before_action :set_booking, only: [:destroy, :status!]

  def index
    if params[:query] == 'sent'
      @bookings = Booking.where("user_id = ?", current_user)
    else
      @bookings = current_user.planets.map { |planet| planet.bookings }.flatten
    end
  end

  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.planet = @planet
    @booking.user = current_user
    if @booking.save
      redirect_to planet_path(@planet)
    else
      render "new"
    end
  end

  def destroy
    @booking.destroy
    redirect_to bookings_path, notice: 'Your booking has been deleted successfully.'
  end

  def status!
    if params[:query] == 'accepted'
      @booking.update(status: 'accepted')
    else
      @booking.update(status: 'rejected')
    end
    redirect_to bookings_path
  end

  private

  def set_planet
    @planet = Planet.find(params[:planet_id])
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:user_id, :start_date, :end_date, :number_of_guests)
  end
end
