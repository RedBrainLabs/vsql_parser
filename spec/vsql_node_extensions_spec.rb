require 'spec_helper'

describe "Node Extensions" do
  include TestChamber

  describe "Select Expression" do
    it "extracts the query output names" do
      parse('SELECT field1 AS f1, table.field2, field3, field4 AS "field 4", table2.*').select_statement.expressions.map(&:name).should ==
        ["f1", "field2", "field3", "field 4", '*']
    end
  end
end
