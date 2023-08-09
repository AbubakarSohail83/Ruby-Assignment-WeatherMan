# frozen_string_literal: true

require_relative 'file_reading'
class YearlyWeatherMetrics
  include FileReading
  attr_accessor :max_yearly_temp, :min_yearly_temp, :max_humidity

  def initialize(year, path)
    year = year.to_s
    @max_yearly_temp = { month: '', val: -100.0 }
    @min_yearly_temp = { month: '', val: Float::INFINITY }
    @max_humidity = { month: '', val: 0.0 }
    @files_data = read_files_from_folder(path, year) # got all the required files in the form of arrays
    calculate_extreme_temperature
  end

  def calculate_extreme_temperature
    temp_data = [
      { month: '', val: 0.0, operator: '>', index: 1, result: @max_yearly_temp },
      { month: '', val: 0.0, operator: '<', index: 3, result: @min_yearly_temp },
      { month: '', val: 0.0, operator: '>', index: 7, result: @max_humidity }
    ]
    @files_data.each do |file|
      file.each do |line|
        temp_data.each do |temp|
          temp[:month] = line.chomp.split(',')[0].to_s
          temp[:val] = line.chomp.split(',')[temp[:index]].to_f
          if temp[:val].send(temp[:operator], temp[:result][:val])
            temp[:result][:month] = temp[:month]
            temp[:result][:val] = temp[:val]
          end
        end
      end
    end
  rescue StandardError => e
    p e.message
    p e.backtrace_locations
  end
end

# # frozen_string_literal: true

# require_relative 'file_reading'
# class YearlyWeatherMetrics
#   include FileReading
#   attr_accessor :max_yearly_temp, :min_yearly_temp, :max_humidity

#   def initialize(year, path)
#     year = year.to_s
#     @max_yearly_temp = { month: '', temp: -100.0 }
#     @min_yearly_temp = { month: '', temp: Float::INFINITY }
#     @max_humidity = { month: '', humidity: 0.0 }
#     @files_data = read_files_from_folder(path, year) # got all the required files in the form of arrays
#     calculate_extreme_temperature('max_temp')
#     calculate_extreme_temperature('min_temp')
#     calculate_extreme_temperature('max_humid')
#   end

#   def calculate_extreme_temperature(type)
#     temp_data = { month: '', value: 0.0 }
#     @files_data.each do |file|
#       file.each do |line|
#         temp_data[:month] = line.chomp.split(',')[0].to_s
#         case type
#         when 'max_temp'
#           temp_data[:value] = line.chomp.split(',')[1].to_f
#           if temp_data[:value] > @max_yearly_temp[:temp]
#             @max_yearly_temp[:month] = temp_data[:month]
#             @max_yearly_temp[:temp] = temp_data[:value]
#           end
#         when 'min_temp'
#           temp_data[:value] = line.chomp.split(',')[3].to_f
#           if temp_data[:value] < @min_yearly_temp[:temp]
#             @min_yearly_temp[:month] = temp_data[:month]
#             @min_yearly_temp[:temp] = temp_data[:value]
#           end
#         when 'max_humid'
#           temp_data[:value] = line.chomp.split(',')[7].to_f
#           if temp_data[:value] > @max_humidity[:humidity]
#             @max_humidity[:month] = temp_data[:month]
#             @max_humidity[:humidity] = temp_data[:value]
#           end
#         end
#       end
#     end
#   rescue StandardError => e
#     p e.backtrace_locations
#   end
# end
