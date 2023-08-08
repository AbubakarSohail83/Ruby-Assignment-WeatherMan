# frozen_string_literal: true

require 'csv'
require 'colorize'
module FileReading
  def read_files_from_folder(path_of_folder, date)
    Dir.glob("#{path_of_folder}/*.txt").select { |filename| filename.include?(date.to_s) }
  rescue StandardError => e
    e.message
  end

  def draw_monthly_weather_chart(file_name)
    count = 1
    File.open(file_name, 'r') do |file|
      file.each_line do |line|
        line_parts = line.chomp.split(',')
        next if line_parts.empty? # next if line.include?('TemperatureC') || line.include?('<')
        next unless line_parts[0].match?(/^\d{4}-\d{1,2}-\d{1,2}/)

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
    e.message
  end

  def read_average_metrics(file_name, type)
    sum = 0.0
    count = 0
    File.open(file_name, 'r') do |file|
      file.each_line do |line|
        line_parts = line.chomp.split(',')
        next if line_parts.empty?
        next unless line_parts[0].match?(/^\d{4}-\d{1,2}-\d{1,2}/)

        count += 1
        case type
        when 'humidity'
          sum += line_parts[8].to_f
        when 'highTemp'
          sum += line_parts[1].to_f
        when 'lowTemp'
          sum += line_parts[3].to_f
        end
      end
    end
    (sum / count).round(2)
  end

  def read_max_humidity(file_name)
    max_monthly_humidity = { month: '', humidity: 0.0 }
    File.open(file_name, 'r') do |file|
      file.each_line do |line|
        next if line.chomp.split(',').empty?

        temp_humidity = line.chomp.split(',')[8].to_f
        if temp_humidity > max_monthly_humidity[:humidity]
          max_monthly_humidity[:month] = line.split(',')[0]
          max_monthly_humidity[:humidity] = temp_humidity
        end
      end
    end
    max_monthly_humidity
  rescue StandardError => e
    p e.message
  end
end

def read_extreme_temp_from_file(file_name, type)
  monthly_temp_for_min_initialize = false
  monthly_temp = { month: '', temp: 0.0 }
  File.open(file_name, 'r') do |file|
    file.each_line do |line|
      next if line.chomp.split(',').empty?

      unless monthly_temp_for_min_initialize
        if line.chomp.split(',')[0].match?(/^\d{4}-\d{1,2}-\d{1,2}/)
          monthly_temp[:temp] =
            line.chomp.split(',')[3].to_f
        end
        monthly_temp[:month] = line.chomp.split(',')[0] if line.chomp.split(',')[0].match?(/^\d{4}-\d{1,2}-\d{1,2}/)
        monthly_temp_for_min_initialize = true if line.chomp.split(',')[0].match?(/^\d{4}-\d{1,2}-\d{1,2}/)
      end
      if type == 'max'
        temp = line.chomp.split(',')[1].to_f
        if temp > monthly_temp[:temp]
          monthly_temp[:month] = line.split(',')[0]
          monthly_temp[:temp] = temp
        end
      elsif type == 'min'
        if line.chomp.split(',')[0].match?(/^\d{4}-\d{1,2}-\d{1,2}/) && (line.chomp.split(',')[3].to_s != '')
          temp = line.chomp.split(',')[3].to_f
        end
        if !temp.nil? && temp < monthly_temp[:temp]
          monthly_temp[:month] = line.split(',')[0]
          monthly_temp[:temp] = temp
        end
      end
    end
  end
  monthly_temp
rescue StandardError => e
  p e.message
end
