require 'suitable_formatter'
require 'suitable_formatter/formatter'
require 'thor'
require 'csv'

module SuitableFormatter
    class CLI < Thor
        desc 'backward read_file.csv write_file.csv pattern_file.txt', ''
        def backward(read_file, write_file, pattern_file, slice_regexp = nil)
            patterns = []
            path = File.expand_path(pattern_file)
            File.open(path) do |file|
                file.each_line do |row|
                    patterns.push(row.chomp)
                end
            end
            Document.new(Formatter::Backward.new(patterns, slice_regexp)).build(read_file, write_file)
        end

        desc 'desc file.csv 0', 'Sort by field in descending order.'
        def desc(file, field = 0)
            path = File.expand_path(file)
            write_file = File.expand_path(File.dirname(path) + '/desc_' + File.basename(path))
            Document.new(Formatter::Desc.new(field)).build(path, write_file)
        end

        desc 'extract_duplicate base.csv target.csv [--option]', 'Extract duplicates.'
        option :aggregate, :type => :boolean, :aliases => :a
        def extract_duplicate(base_file, target_file, field = 0)
            contents = [base_file, target_file]
                .map {|file| File.expand_path(file)}
                .map {|path| Document::read(path)}

            values = contents[1].map {|c| c[field.to_i]}.to_set
            duplication = contents[0].to_set.select {|content|
                values.include?(content[field.to_i])
            }

            path = File.expand_path(base_file)
            write_file = File.expand_path(File.dirname(path) + '/duplication_' + File.basename(path))
            Document::write(duplication, write_file, 'w')
            if options.aggregate
                puts duplication.count
                puts ((contents[0].count.to_f / contents[1].count) * 100).round(2)
            end
        end
    end

    class Document
        def initialize(formatter)
            @formatter = formatter
        end

        def build(read_file, write_file, *args)
            rows = Document.read(read_file)
            write_list = @formatter.format(rows, *args)
            Document.write(write_list, write_file, 'w')
        end

        def self.write(write_list, file_name, mode)
            CSV.open(file_name, mode) do |file|
                write_list.each{ |row|
                    file << row
                }
            end
        end

        def self.read(file_name)
            return CSV.read(file_name);
        end
    end
end
