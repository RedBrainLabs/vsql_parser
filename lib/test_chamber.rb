# In file parser.rb
require_relative './sql_parser.rb'

NORMAL_COLOR ||= 37
def colorize(color, output)
  "\e[0;#{color}m#{output}\e[0;#{NORMAL_COLOR}m"
end

class Parser

  # Load the Treetop grammar from the 'sql_parser' file, and
  # create a new instance of that parser as a class variable
  # so we don't have to re-create it every time we need to
  # parse a string
  $p = @@parser = SqlParser.new

  def self.parser
    @@parser
  end

  def self.parse(data)
    # Pass the data over to the parser instance
    tree = @@parser.parse(data.downcase)

    # If the AST is nil then there was an error during parsing
    # we need to report a simple error message to help the user
    if(tree.nil?)
      STDERR.puts
      STDERR.puts( colorize(42, data[0..(@@parser.max_terminal_failure_index - 1)]) +
                   colorize(41, data[(@@parser.max_terminal_failure_index)..-1]))
      STDERR.puts
      raise Exception, @@parser.failure_reason
      # STDERR.puts @@parser.failure_reason
      # return @@parser
    end

    # clean_tree(tree)
    return tree
  end


  private

  def self.clean_tree(root_node)
    return if(root_node.elements.nil?)
    root_node.elements.delete_if{|node| node.class.name == "Treetop::Runtime::SyntaxNode" }
    root_node.elements.each {|node| self.clean_tree(node) }
  end
end

def reload
  Object.send(:remove_const, :Parser) rescue nil
  Object.send(:remove_const, :SqlParser) rescue nil
  Object.send(:remove_const, :Sql) rescue nil
  load(File.join(SQLPARSER_BASE_PATH, 'node_extensions.rb'))
  Treetop.load(File.join(SQLPARSER_BASE_PATH, 'sql_parser.treetop'))
  load(__FILE__)
end
