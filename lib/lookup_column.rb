require 'lookup_column/version'

# The main gem classes
module LookupColumn
  def self.included(base)
    # base is our target class. Invoke `extend` on it and pass nested module
    # with class methods.
    base.extend ClassMethods
  end

  # Class methods
  module ClassMethods

    def lookup_group(name, column)
      @lookup_group = LookupGroup.new(name, column)
      lookup_columns << @lookup_group
    end

    def option(id, code, display, data = {})
      @lookup_group.add_option(EnumOption.new(id, code, display, data))
    end

    def lookup_groups
      @lookup_groups ||= []
    end

    def respond_to?(method, priv = false)
      method_names = lookup_groups.map { |c| c.name.to_s }
      (method_names.include? method.to_s) || super
    end

    def method_missing(sym, *args)
      super
      # method_names = lookup_groups.map { |c| c.name.to_s }
      # if method_namesym.to_s =~ /^is_a_(\w+)$/
      #   pattern = $1
      #   # then just do something with pattern here, e.g.:
      #   # puts pattern
      # else
      #   super
      # end
    end
  end

  private

  # LookupOption represents a single option for a column
  class LookupOption
    attr_reader :id, :code, :display, :data
    def initialize(id, code, display, data = {})
      @id = id
      @code = code
      @display = display


      @data = data
    end
  end

  # LookupGroup
  class LookupGroup
    attr_reader :name, :column, :options
    def initialize(name, column)
      @name = name
      @column = column
      @options = []
    end

    def add_option(option)
      options << option
    end
  end

end
