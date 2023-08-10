# frozen_string_literal: true

module FileReading
  def read_files_from_folder(path_of_folder, date)
    file_names_array = Dir.glob("#{path_of_folder}/*.txt").select { |filename| filename.include?(date.to_s) }
    data_array = []
    file_names_array.each do |file_name|
      data_array.concat File.readlines(file_name)
    end
    data_array.delete_if { |line| !valid_line?(line) }
  rescue StandardError => e
    e.backtrace_locations
  end

  def valid_line?(line)
    !line.include?('<!--') && !line.include?('Mean TemperatureC') && !line.chomp.empty?
  end
end
