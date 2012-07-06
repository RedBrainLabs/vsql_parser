# In file parser.rb
require 'treetop'

# Find out what our base path is
BASE_PATH ||= File.expand_path(File.dirname(__FILE__))

# Load our custom syntax node classes so the parser can use them
load File.join(BASE_PATH, 'node_extensions.rb')

class Parser

  # Load the Treetop grammar from the 'sql_parser' file, and
  # create a new instance of that parser as a class variable
  # so we don't have to re-create it every time we need to
  # parse a string
  Treetop.load(File.join(BASE_PATH, 'sql_parser.treetop'))
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
      raise Exception, @@parser.failure_reason
      STDERR.puts @@parser.failure_reason
      return @@parser
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
  load(__FILE__)
end
