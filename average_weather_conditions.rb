# frozen_string_literal: true

require 'date'
require_relative 'file_reading'

class AverageWeatherConditions
  attr_accessor :avg_highest_temperature, :avg_lowest_temperature, :avg_humidity

  include FileReading

  def initialize(date, path)
    @path_of_folder = path
    date_arr = date.to_s.chomp.split('/')
    @month = (Date::MONTHNAMES[date_arr[1].to_i]).to_s[0, 3]
    @year = date_arr[0].to_s
    @file_name = read_files_from_folder(path, "#{@year}_#{@month}")[0]
    calculate_average_highest_temperature
    calculate_average_lowest_temperature
    calculate_average_humidity
  rescue StandardError => e
    p e.message
  end

  def calculate_average_highest_temperature
    @avg_highest_temperature = read_average_metrics(@file_name, 'highTemp')
  end

  def calculate_average_lowest_temperature
    @avg_lowest_temperature = read_average_metrics(@file_name, 'lowTemp')
  end

  def calculate_average_humidity
    @avg_humidity = read_average_metrics(@file_name, 'humidity')
  end
end
