# frozen_string_literal: true

module FileReading
  def read_files_from_folder(path_of_folder, date)
    file_names_array = Dir.glob("#{path_of_folder}/*.txt").select { |filename| filename.include?(date.to_s) }
    files_array = []
    file_names_array.each do |file_name|
      individual_file_content = []
      File.open(file_name, 'r') do |file|
        file.each_line do |file_line|
          individual_file_content.push(file_line) if valid_line?(file_line.chomp)
        end
      end
      files_array.push(individual_file_content)
    end
    files_array
  rescue StandardError => e
    e.backtrace_locations
  end

  def valid_line?(line)
    !(line.include?('<!-- 0.210:0 -->') || line.include?('Mean TemperatureC') || line.split(',')[1].nil?)
  end
end
