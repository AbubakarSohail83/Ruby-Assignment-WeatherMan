# frozen_string_literal: true

require_relative 'yearly_weather_metrics'
require_relative 'monthly_weather_metrics'

begin
  valid_flags = %w[-e -a -c]
  raise StandardError, 'Not Enough Arguments' if ARGV.count != 3
  raise StandardError, 'Not valid flag' unless valid_flags.include?(ARGV[0])

  flag = ARGV[0]
  raise StandardError, 'Date is not in the correct format(YYYY)!' if flag == '-e' && !ARGV[1].match?(/^\d{4}$/)
  if flag != '-e' && !ARGV[1].match?(%r{^\d{4}/\d{1,2}$})
    raise StandardError, 'Date is not in the correct format(YYYY/MM)!'
  end

  date = ARGV[1]
  path = ARGV[2]
  case flag
  when '-e'
    yearly_weather = YearlyWeatherMetrics.new(date, path)

    puts "Highest: #{yearly_weather.max_temp[:val]}C on #{yearly_weather.max_temp[:month]}"
    puts "Lowest: #{yearly_weather.min_temp[:val]}C on #{yearly_weather.min_temp[:month]}"
    puts "Humid: #{yearly_weather.max_humidity[:val]}% on #{yearly_weather.max_humidity[:month]}"
  when '-a'
    average_weather = MonthlyWeatherMetrics.new(date, path)
    puts "Highest Average: #{average_weather.avg_max_temp[:result]} C "
    puts "Lowest Average: #{average_weather.avg_min_temp[:result]} C "
    puts "Average Humidity: #{average_weather.avg_humidity[:result]} % "
  when '-c'
    draw_chart = MonthlyWeatherMetrics.new(date, path)
    draw_chart.draw_monthly_weather_chart

  end
rescue StandardError => e
  puts e.message
  puts e.backtrace_locations
end
