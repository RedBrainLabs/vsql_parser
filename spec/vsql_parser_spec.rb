require 'spec_helper'

describe VSqlParser do
  include TestChamber

  def assert_parse(sql)
    running {
      parse sql
    }.should_not raise_error
  end

  def select_expressions(sql)
    parse(sql).select_statement.expressions.map(&:text_value)
  end
  
  context "expression parsing" do
    it "parses complex arithmetic expressions" do
      assert_parse("SELECT ((a + b) / 5) + c")
      assert_parse("SELECT ((a+b)/5)+c")
    end

    it "parses typecasts" do
      assert_parse("SELECT true::integer")
      assert_parse("SELECT (not true)::integer")
    end

    it "parses multiple expressions with mixed aliases" do
      select_expressions("SELECT a, b.*, c AS field3, great").should == ["a", "b.*", "c AS field3", "great"]
    end

    it "parses fields with surrounded by \"'s" do
      assert_parse('SELECT "table.field with spaces for whatever reason" FROM table')
    end

    it "parses fields with specified source" do
      assert_parse("SELECT table.field FROM table")
    end

    it "parses string literals" do
      assert_parse("SELECT 'value'")
    end

    it "parses case statements" do
      assert_parse("SELECT CASE WHEN not table.boolean THEN 5 ELSE NULL END")
    end

    it "parses functions" do
      select_expressions("SELECT least(a,b),greatest(c,d + (5+LEAST(3,3)))").should ==
        [ "least(a,b)",
          "greatest(c,d + (5+LEAST(3,3)))" ]
    end

    it "parses boolean inverse expressions" do
      assert_parse("SELECT NOT true")
    end

    it "handles alises" do
      assert_parse("SELECT a AS alias1 FROM table;")
    end


    it "parses subqueries" do
      assert_parse("SELECT v in (select value from table2) as value_exists from table")
    end
  end

  context "FROM parsing" do
    it "handles aliases" do
      assert_parse("SELECT v FROM table t")
    end

    it "can select from a subquery" do
      assert_parse("SELECT v FROM (SELECT y from table) t")
    end
  end

  context "JOIN" do
    it "parses a simple join" do
      assert_parse "SELECT * FROM table t INNER JOIN table2 t2 ON t2.table_id = t.id"
    end

    it "parses a series of joins" do
      assert_parse <<-EOF
SELECT * FROM table
INNER      JOIN table2 t2 ON (    t2.table_id = table.id) AND (true)
LEFT       JOIN table3 t3 ON (    t3.table_id = table.id) AND (true)
FULL OUTER JOIN table4    ON (table4.table_id = table.id) AND (true)
EOF
    end

  end

  context "UNION" do
    it "handles unions" do
      assert_parse("SELECT * FROM (SELECT * FROM table1 UNION SELECT * FROM table2) t")
    end
  end

  context "WHERE" do
    it "supports simple where expressions" do
      assert_parse("SELECT * FROM table WHERE true")
    end
    
    it "supports nested AND / OR expressions" do
      assert_parse("SELECT * FROM table WHERE (field1 = field2 OR field1 IS NULL) AND (field2 > (field3 + 5))")
    end
  end

  context "GROUP BY" do
    it "can group by many fields, including functions and mathmatecial expressions" do
      assert_parse("SELECT * FROM table GROUP BY date(field1), field2, field3 / 5, field4")
    end
  end

  context "HAVING" do
    it "supports simple where expressions" do
      assert_parse("SELECT * FROM table HAVING COUNT(*) > 1")
    end
    
    it "supports nested AND / OR expressions" do
      assert_parse("SELECT * FROM table HAVING COUNT(*) > 1 AND (count(agent.*) = 0 OR count(calls.*) = 0)")
    end
  end

  context "ORDER BY" do
    it "allows specification of order" do
      assert_parse("SELECT * FROM table ORDER BY field1 DESC, field2 ASC")
    end

    it "allows functions" do
      assert_parse("SELECT * FROM table ORDER BY date(field1) DESC")
    end
  end

  it "parses limit statements" do
    assert_parse("SELECT * FROM table LIMIT 1")
  end

end
