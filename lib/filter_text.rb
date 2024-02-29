#This ruby code is used to filter out text.txt for words that are less than 5 letters 

#reads the entire file and returns an array
lines = File.readlines('original_text.txt')

#.select: filter elements from an array based on a condition. It iterates over each element of the array and selects only those elements for which the block (the code between do and end) returns true.

# strip removes leading and trailing whitespace characters from the string 

filtered_lines = lines.select do |line|
  line.strip.length >= 5
end

output_file = 'filtered_text.txt'

if !File.exist?(output_file)
    File.open(output_file, 'w') do |file|
        file.puts(filtered_lines)
    end
else
    puts "File '#{output_file}' already exists. Choose a different name."
end