# frozen_string_literal: true

require_relative 'file_reading'
require 'byebug'
class YearlyWeatherMetrics
  include FileReading
  attr_accessor :max_temp, :min_temp, :max_humidity

  def initialize(year, path)
    @max_temp = {}
    @min_temp = {}
    @max_humidity = {}
    @files_data = read_files_from_folder(path, year)
    calculate_extreme_temperature
  end

  def calculate_extreme_temperature
    @max_temp[:val] = @files_data[0].split(',')[1]
    @min_temp[:val] = @files_data[0].split(',')[3]
    @max_humidity[:val] = @files_data[0].split(',')[7]

    @files_data.each do |line|
      if line.split(',')[1].to_f > @max_temp[:val].to_f
        @max_temp[:val] = line.split(',')[1]
        @max_temp[:month] = line.split(',')[0]
      end
      if line.split(',')[3].to_f < @min_temp[:val].to_f
        @min_temp[:val] = line.split(',')[3]
        @min_temp[:month] = line.split(',')[0]
      end
      if line.split(',')[7].to_f > @max_humidity[:val].to_f
        @max_humidity[:val] = line.split(',')[7]
        @max_humidity[:month] = line.split(',')[0]
      end
    end
  rescue StandardError => e
    p e.message
    p e.backtrace_locations
  end
end
