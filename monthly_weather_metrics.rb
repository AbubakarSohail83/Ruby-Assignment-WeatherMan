# frozen_string_literal: true

require_relative 'file_reading'
class MonthlyWeatherMetrics
  include FileReading
  attr_accessor :avg_highest_temp, :avg_lowest_temp, :avg_humidity

  def initialize(date, path)
    months={1=>'Jan', 2=>'Feb',3=>'Mar',4=>'Apr',5=>'May',6=>'Jun',7=>'Jul',8=>'Aug',9=>'Sep',10=>'Oct',11=>'Nov',12=>'Dec'}
    date_arr = date.to_s.chomp.split('/')
    month = months[date_arr[1].to_i]
    year = date_arr[0].to_s
    @file_data = read_files_from_folder(path,"#{year}_#{month}")
    @avg_highest_temp=calc_avg_metrics('avg_max_temp')
    @avg_lowest_temp=calc_avg_metrics('avg_min_temp')
    @avg_humidity=calc_avg_metrics('avg_humidity')
  end

  def calc_avg_metrics(type)
    sum=0.0
    count=0.0
    if !@file_data.nil?
      @file_data.each do |file|
        file.each do |line|
          case type
          when 'avg_max_temp'
            sum+=line.chomp.split(',')[1].to_f
          when 'avg_min_temp'
            sum+=line.chomp.split(',')[3].to_f
          when 'avg_humidity'
            sum+=line.chomp.split(',')[7].to_f
          end
          count+=1
        end
      end
      return (sum/count).round(2)
    end
    rescue StandardError => e
      p e.message
    end
  end
