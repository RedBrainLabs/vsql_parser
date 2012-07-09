module VSql
  module Helpers
    def self.find_elements(node, klass, skip_klass = nil)
      results = []
      return results unless node.elements
      node.elements.each do |e|
        case
        when e.is_a?(klass)
          results << e
        when skip_klass && e.is_a?(skip_klass)
          next
        else
          results.concat(find_elements(e, klass, skip_klass))
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
    def expression_sql
    end

    def alias_node
      @alias_node ||= Helpers.find_elements(self, Alias, Query).first
    end

    def name
      return alias_node.text_value if alias_node
      case text_value
      when /\*$/ then "*"
      when /^(\w+\.)?(\w+)$/ then $2
      end
    end
  end

  class Alias < Treetop::Runtime::SyntaxNode
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
