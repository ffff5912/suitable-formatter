require 'suitable_formatter'
require 'thor'
require 'csv'

module SuitableFormatter
    class CLI < Thor
        desc 'backward read_file.csv write_file.csv pattern_file.txt', '' # コマンドの使用例と、概要
        def backward(read_file, write_file, pattern_file)
            patterns = []
            path = File.expand_path(pattern_file)
            File.open(path) do |file|
                file.each_line do |row|
                    patterns.push(row.chomp)
                end
            end

            formatter = Formatter.new(read_file, write_file, patterns)
            formatter.build()
        end
    end

    class Formatter
        def initialize(read_file, write_file, patterns)
            @read_file = read_file
            @write_file = write_file
            @patterns = patterns
        end

        def build
            mail_list = read(@read_file)
            write_list = mail_list.select{ |mail|
                nil == filter(mail[0])
            }
            write(write_list, @write_file, 'w')
            output(mail_list, write_list)
        end

        def write(write_list, file_name, mode)
            CSV.open(file_name, mode) do |file|
                write_list.each{ |row|
                    file << row
                }
            end
        end

        def read(file_name)
            return CSV.read(file_name);
        end

        def filter(target)
            return target.match(/(#{@patterns.join('|')})$/)
        end

        def output(mail_list, write_list)
            puts mail_list.count
            puts write_list.count
            puts "Filtered:#{mail_list.count - write_list.count}"
        end
    end
end
