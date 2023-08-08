# frozen_string_literal: true

require_relative 'file_reading'
class ExtremeWeatherConditions
  include FileReading
  attr_accessor :max_yearly_temp, :min_yearly_temp, :max_humidity

  def initialize(year, path)
    @year = year.to_s
    @path_of_folder = path
    @max_yearly_temp = { month: '', temp: 0.0 }
    @min_yearly_temp = { month: '', temp: Float::INFINITY }
    @max_humidity = { month: '', humidity: 0.0 }
    @file_names = read_files_from_folder(@path_of_folder, @year)
    calculate_highest_temperature
    calculate_lowest_temperature
    calculate_max_humidity
  end

  def calculate_highest_temperature
    @file_names.each do |file_name|
      temp_data = read_extreme_temp_from_file(file_name, 'max')
      if temp_data[:temp] > @max_yearly_temp[:temp]
        @max_yearly_temp[:month] = temp_data[:month]
        @max_yearly_temp[:temp] = temp_data[:temp]
      end
    end
  rescue StandardError => e
    p e.message
  end

  def calculate_lowest_temperature
    @file_names.each do |file_name|
      temp_data = read_extreme_temp_from_file(file_name, 'min')
      if temp_data[:temp] < @min_yearly_temp[:temp]
        @min_yearly_temp[:month] = temp_data[:month]
        @min_yearly_temp[:temp] = temp_data[:temp]
      end
    end
  rescue StandardError => e
    p e.message
  end

  def calculate_max_humidity
    @file_names.each do |file_name|
      temp_data = read_max_humidity(file_name)
      if temp_data[:humidity] > @max_humidity[:humidity]
        @max_humidity[:month] = temp_data[:month]
        @max_humidity[:humidity] = temp_data[:humidity]
      end
    end
  rescue StandardError => e
    p e.message
  end
end
