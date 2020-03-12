require 'require_all'
require 'uri'
require_all '../lib/**/*.rb'

class Main
  attr_accessor :input, :output_format, :sort, :input_format
  def initialize(options)
    @input = options[:input]
    @output_format = options[:output_format]
    @sort = options[:sort]
    @input_format = ''
  end
  
  def run
    data = if @input =~ URI::regexp
             LinkReader.read(@input)
           elsif File.file?(@input)
             FileReader.read(@input)
           else
             puts 'ERROR: Not found file'
             exit
           end

    input_format = InputFormat.format(data)
    parsed_data = if input_format == 'rss'
                    RssParser.parse(data)
                  elsif input_format == 'json'
                    JsonParser.parse(data)
                  elsif input_format == 'atom'
                    AtomParser.parse(data)
                  end
                puts parsed_data[:item][0]
    # # parsed_data = if @sort == 'asc'
    # #                 AscSorter.sort(parsed_data)
    # #               else
    # #                 DescSorter.sort(parsed_data)
    # #               end
    
    # if @output_format == 'json'
    #   ToJsonConvert.convert(parsed_data, input)
    # elsif @output_format == 'atom'
    #   ToAtomConvert.convert(parsed_data, input)
    # elsif @output_format == 'rss'
    #   ToRssConvert.convert(parsed_data, input)
    # end
  end
end