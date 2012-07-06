# In file parser.rb
require 'treetop'
require_relative './vsql_node_extensions.rb'

VSQLPARSER_BASE_PATH ||= File.expand_path(File.dirname(__FILE__))
# Find out what our base path is
Treetop.load(File.join(VSQLPARSER_BASE_PATH, 'vsql_parser.treetop')) # <- This creates the VSqlParser class

