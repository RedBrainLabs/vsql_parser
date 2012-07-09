# In file parser.rb
require 'treetop'
require_relative './vsql_node_extensions.rb'

VSQLPARSER_BASE_PATH ||= File.expand_path(File.dirname(__FILE__))

module VSqlParserHelpers
  def parser
    @parser ||= VSqlParser.new
  end

  def parse(sql)
    d_sql = sql.downcase
    parser.parse(d_sql).tap do
      d_sql.replace(sql)
    end
  end
end

# Find out what our base path is
Treetop.load(File.join(VSQLPARSER_BASE_PATH, 'vsql_parser.treetop')) # <- This creates the VSqlParser class

VSqlParser.extend(VSqlParserHelpers)

