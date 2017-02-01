require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]

    # ==========================================================================
    # Your code goes below.
    #
    # The street address that the user typed is in the variable @street_address.
    # ==========================================================================

    @street_address_without_spaces = @street_address.gsub(" ", "+")

    @goog_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + @street_address_without_spaces

    parsed_goog_data = JSON.parse(open(@goog_url).read)

    @lat = parsed_goog_data["results"][0]["geometry"]["location"]["lat"].to_s

    @lng = parsed_goog_data["results"][0]["geometry"]["location"]["lng"].to_s

    @dark_url = "https://api.darksky.net/forecast/115af5184f68a01dcca0dbd60201e8a2/" + @lat + "," + @lng

    parsed_data = JSON.parse(open(@dark_url).read)

    @current_temperature = parsed_data["currently"]["temperature"]

    @current_summary = parsed_data["currently"]["summary"]

    @summary_of_next_sixty_minutes = parsed_data["minutely"]["summary"]

    @summary_of_next_several_hours = parsed_data["hourly"]["summary"]

    @summary_of_next_several_days = parsed_data["daily"]["summary"]

    render("meteorologist/street_to_weather.html.erb")
  end
end
