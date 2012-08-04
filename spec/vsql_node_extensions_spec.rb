require 'spec_helper'

describe "Node Extensions" do
  include TestChamber

  describe VSql::SelectExpression do
    def expressions_for(sql)
      parse(sql).select_statement.expressions
    end

    describe "#name" do
      it "returns the name for aliases" do
        expressions = expressions_for('SELECT field1 AS f1, field2 AS "field 2"')
        expressions.map(&:name).should == ["f1", "field 2"]
      end

      it "infers the name from fields when no alias specified" do
        expressions = expressions_for('SELECT table.field1, field2')
        expressions.map(&:name).should == ["field1", "field2"]
      end

      it "returns * for expressions selecting from *" do
        expressions = expressions_for('SELECT table.*, *')
        expressions.map(&:name).should == ["*", "*"]
      end

      it "returns ?column? for expressions selecting from complex expressions" do
        expressions = expressions_for('SELECT count(*) + 1, case when true then 3 else 2 end, "table"."field" + 5')
        expressions.map(&:name).should == ["?column?", "?column?", "?column?"]
      end

      it "returns quoted fields as the field" do
        expressions = expressions_for('SELECT "my table"."*_date", "boogie"')
        expressions.map(&:name).should == ["*_date", "boogie"]
      end

      it "returns the function name" do
        expressions = expressions_for('SELECT count(*), min(field1)')
        expressions.map(&:name).should == ["count", "min"]
      end

    end
  end
end
