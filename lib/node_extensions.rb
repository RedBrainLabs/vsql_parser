module Sql
  module Helpers
    def self.find_elements(node, klass)
      results = []
      return results unless node.elements
      node.elements.each do |e|
        if e.is_a?(klass)
          results << e
        else
          results.concat(find_elements(e, klass))
        end
      end
      results
    end
  end

  class Operator < Treetop::Runtime::SyntaxNode
  end

  class Statement < Treetop::Runtime::SyntaxNode
  end

  class SelectStatement < Treetop::Runtime::SyntaxNode
    def expressions
      Helpers.find_elements(self, SelectExpression)
    end
  end

  class SelectExpression < Treetop::Runtime::SyntaxNode
  end

  class Entity < Treetop::Runtime::SyntaxNode
    # def to_array
    #   return self.elements[0].to_array
    # end
  end

  class QuotedEntity < Entity
  end

  class Query < Treetop::Runtime::SyntaxNode
    # def to_array
    #   return self.elements.map {|x| x.to_array}
    # end
    # def select_statement
    #   elements.detect { |e| e.is_a?(SelectStatement) }
    # end
  end
end
