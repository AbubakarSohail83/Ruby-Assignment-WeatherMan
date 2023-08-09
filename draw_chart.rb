# # frozen_string_literal: true

# require_relative 'file_reading'
# require 'colorize'

# class DrawChart
#   include FileReading
#   def initialize(date, path)
#     @path_of_folder = path
#     @date_arr = date.to_s.chomp.split('/')
#     @month = (Date::MONTHNAMES[@date_arr[1].to_i]).to_s[0, 3]
#     @year = @date_arr[0].to_s
#     @file_name = read_files_from_folder(path, "#{@year}_#{@month}")[0]
#   end

#   def draw_chart
#     puts "#{Date::MONTHNAMES[@date_arr[1].to_i]} #{@year}"
#     draw_monthly_weather_chart(@file_name)
#   end
# end
