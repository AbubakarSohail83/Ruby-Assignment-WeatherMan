# frozen_string_literal: true

require 'colorize'
require_relative 'file_reading'
class MonthlyWeatherMetrics
  include FileReading
  attr_accessor :avg_highest_temp, :avg_lowest_temp, :avg_humidity

  def initialize(date, path)
    months = {
      1 => 'Jan',
      2 => 'Feb',
      3 => 'Mar',
      4 => 'Apr',
      5 => 'May',
      6 => 'Jun',
      7 => 'Jul',
      8 => 'Aug',
      9 => 'Sep',
      10 => 'Oct',
      11 => 'Nov',
      12 => 'Dec'
    }
    date_arr = date.to_s.chomp.split('/')
    @month = months[date_arr[1].to_i]
    @year = date_arr[0].to_s
    @file_data = read_files_from_folder(path, "#{@year}_#{@month}")
    calc_avg_metrics
  end

  def calc_avg_metrics
    temp_data = [
      { sum: 0.0,  index: 1, result: 0.0 },
      { sum: 0.0,  index: 3, result: 0.0 },
      { sum: 0.0,  index: 7, result: 0.0 }
    ]
    count = 0.0
    @file_data.each do |file|
      file.each do |line|
        temp_data.each do |temp|
          temp[:sum] += line.chomp.split(',')[temp[:index]].to_f
        end
        count += 1
      end
    end
    temp_data.each do |temp|
      temp[:result] = (temp[:sum] / count).round(2)
    end
    @avg_highest_temp = temp_data[0][:result]
    @avg_lowest_temp = temp_data[1][:result]
    @avg_humidity = temp_data[2][:result]
  rescue StandardError => e
    p e.backtrace_locations
    p e.message
  end



  def draw_monthly_weather_chart
    puts "#{@month} #{@year}"
    count = 1
    @file_data.each do |file|
      file.each do |line|
        line_parts = line.chomp.split(',')
        daily_high_temp = line_parts[1].to_i
        daily_low_temp = line_parts[3].to_i
        print count
        daily_high_temp.times do
          print '+'.colorize(:red)
        end
        print " #{daily_high_temp}C \n"
        print count
        daily_low_temp.times do
          print '+'.colorize(:blue)
        end
        print " #{daily_low_temp}C \n"
        count += 1
      end
    end
  rescue StandardError => e
    e.backtrace_locations
  end
end
