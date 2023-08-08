# frozen_string_literal: true

require_relative 'extreme_weather_conditions'
require_relative 'draw_chart'
require_relative 'average_weather_conditions'
require 'date'

class CustomArgumentError < StandardError
  def initialize(message = 'Not Valid Command Line Arguments')
    super(message)
  end
end

begin
  valid_flags = %w[-e -a -c]
  raise CustomArgumentError, 'Not Enough Arguments' if ARGV.count != 3
  raise CustomArgumentError, 'Not valid flag' unless valid_flags.include?(ARGV[0])

  flag = ARGV[0]
  if flag == '-e' && !ARGV[1].match?(/^\d{4}$/)
    raise CustomArgumentError, 'Date is not in the correct format(YYYY)!'
  elsif !ARGV[1].match?(%r{^\d{4}/\d{1,2}$})
    raise CustomArgumentError, 'Date is not in the correct format(YYYY/MM)!'
  end
  date = ARGV[1]
  path = ARGV[2]

  case flag
  when '-e'
    extreme_weather = ExtremeWeatherConditions.new(date, path)
    puts "Highest: #{extreme_weather.max_yearly_temp[:temp]}C on #{extreme_weather.max_yearly_temp[:month]}"
    puts "Lowest: #{extreme_weather.min_yearly_temp[:temp]}C on #{extreme_weather.min_yearly_temp[:month]}"
    puts "Humid: #{extreme_weather.max_humidity[:humidity]}% on #{extreme_weather.max_humidity[:month]}"
  when '-a'
    average_weather = AverageWeatherConditions.new(date, path)
    puts "Highest Average: #{average_weather.avg_highest_temperature} C "
    puts "Lowest Average: #{average_weather.avg_lowest_temperature} C "
    puts "Average Humidity: #{average_weather.avg_humidity} % "
  when '-c'
    draw_chart = DrawChart.new(date, path)
    draw_chart.draw_chart
  end
rescue StandardError => e
  puts e.message
end
