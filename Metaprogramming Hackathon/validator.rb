module Validator
  def self.included(base)
    base.extend ClassMethods    
  end
  
  module ClassMethods
    def validates(attr, &block)
      define_method "#{(attr)=}" do |attr_value|
        unless block.call(attr_value)
          puts "#{attr_value} is invalid value for #{attr}"
        else
          instance_variable_set("@#{attr}", attr_value)
        end
      end
      
      define_method "#{attr}" do
        instance_variable_get("@#{attr}")
      end
    end
  end
end