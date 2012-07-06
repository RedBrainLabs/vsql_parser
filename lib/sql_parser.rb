# In file parser.rb
require 'treetop'
require_relative './node_extensions.rb'

SQLPARSER_BASE_PATH ||= File.expand_path(File.dirname(__FILE__))
# Find out what our base path is
Treetop.load(File.join(SQLPARSER_BASE_PATH, 'sql_parser.treetop'))

