# frozen_string_literal: true

require 'colorize'
module FileReading
  def read_files_from_folder(path_of_folder, date)
    file_names_array=Dir.glob("#{path_of_folder}/*.txt").select { |filename| filename.include?(date.to_s) }
    files_array=[]                         # this will be an array of arrays, where each array will have file line as its element
    file_names_array.each do |file_name|
      individual_file_content=[]
      File.open(file_name,'r') do |file|
        file.each_line do |file_line|
          if !file_line.chomp.include?('<!-- 0.210:0 -->') && !file_line.chomp.include?('Mean TemperatureC') && !file_line.chomp.split(',')[1].nil?
            individual_file_content.push(file_line)
          end
        end
      end
      files_array.push(individual_file_content)
    end
    files_array
  rescue StandardError => e
    e.backtrace_locations
  end
end
