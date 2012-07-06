module Sql
  # class IntegerLiteral < Treetop::Runtime::SyntaxNode
  #   def to_array
  #     return self.text_value.to_i
  #   end
  # end

  # class StringLiteral < Treetop::Runtime::SyntaxNode
  #   def to_array
  #     return eval self.text_value
  #   end
  # end

  # class FloatLiteral < Treetop::Runtime::SyntaxNode
  #   def to_array
  #     return self.text_value.to_f
  #   end
  # end

  # class Identifier < Treetop::Runtime::SyntaxNode
  #   def to_array
  #     return self.text_value.to_sym
  #   end
  # end

  class Operator < Treetop::Runtime::SyntaxNode
  end

  # class ItemsNode < Treetop::Runtime::SyntaxNode
  #   def values
  #     items.values.unshift(item.value)
  #   end
  # end

  # class ItemNode < Treetop::Runtime::SyntaxNode
  #   def values
  #     [value]
  #   end

  #   def value
  #     text_value.to_sym
  #   end
  # end

  class Statement < Treetop::Runtime::SyntaxNode
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
  end
end
