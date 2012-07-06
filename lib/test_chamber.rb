# In file parser.rb
require_relative './sql_parser.rb'

module TestChamber
  module Helpers
    NORMAL_COLOR ||= 37
    def colorize(color, output)
      "\e[0;#{color}m#{output}\e[0;#{NORMAL_COLOR}m"
    end
  end

  PARSER = SqlParser.new
  include Helpers
  extend self

  def parse(sql)
    d_sql = sql.downcase
    PARSER.parse(d_sql).tap do |tree|
      d_sql.replace(sql) # un-downcase it
      # If the AST is nil then there was an error during parsing
      # we need to report a simple error message to help the user
      if tree.nil?
        fail_index = PARSER.max_terminal_failure_index
        STDERR.flush
        STDOUT.flush
        STDERR.puts( "\n" +
                     colorize(42, sql[0..(fail_index - 1)]) +
                     colorize(41, sql[(fail_index)..-1]) +
                     "\n\n")

        STDERR.flush
        raise Exception, PARSER.failure_reason
      end
    end
  end

  private

  def clean_tree(root_node)
    return if(root_node.elements.nil?)
    root_node.elements.delete_if{|node| node.class.name == "Treetop::Runtime::SyntaxNode" }
    root_node.elements.each {|node| self.clean_tree(node) }
  end

  def reload
    Object.send(:remove_const, :SqlParser) rescue nil
    Object.send(:remove_const, :Sql) rescue nil
    TestChamber.send(:remove_const, :PARSER) rescue nil

    load(File.join(SQLPARSER_BASE_PATH, 'node_extensions.rb'))
    Treetop.load(File.join(SQLPARSER_BASE_PATH, 'sql_parser.treetop'))
    load(__FILE__)
  end
end
