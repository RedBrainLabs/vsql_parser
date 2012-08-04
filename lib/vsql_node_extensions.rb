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

    def root_nodes
      elements[0].elements.select { |e| ! e.text_value.empty? }
    end

    def name
      case
      when alias_node
        alias_node.text_value
      when root_nodes.length == 1 && root_nodes.first.is_a?(Function)
        root_nodes.first.name
      when root_nodes.length == 1 && root_nodes.first.is_a?(FieldRef)
        element =
          Helpers.find_elements(self, FieldGlob).last ||
          Helpers.find_elements(self, Name).last
        element.text_value
      else "?column?"
      end
    end
  end

  class Name < Treetop::Runtime::SyntaxNode
  end

  class FieldRef < Treetop::Runtime::SyntaxNode
  end

  class TablePart < Treetop::Runtime::SyntaxNode
  end

  class FieldGlob < Treetop::Runtime::SyntaxNode
  end

  class Alias < Treetop::Runtime::SyntaxNode
  end

  class Function < Treetop::Runtime::SyntaxNode
    def name
      elements[0].text_value
    end
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
