require 'active_support/inflector'

# The main gem classes
module LookupColumn
  def self.included(base)
    # base is our target class. Invoke `extend` on it and pass nested module
    # with class methods.
    base.extend ClassMethods
  end

  def respond_to?(method, priv = false)
    self.class.find_group(method).present? || super
  end

  def method_missing(sym, *args)
    group = self.class.find_group(parse_method_name(sym))
    return execute_method_call(group, sym, args) if group
    super
  end

  def parse_method_name(sym)
    sym_string = sym.to_s
    sym_string = sym_string[0..-2] if sym_string.end_with? '='
    sym_string.to_sym
  end

  def execute_method_call(group, sym, args)
    if sym.to_s.end_with? '='
      send((group.column.to_s + '=').to_sym, args[0].id)
    else
      group.find_option_by_id(send(group.column))
    end
  end

  # Class methods
  module ClassMethods
    def lookup_group(name, column, &block)
      @lookup_group = LookupGroup.new(name, column)
      lookup_groups[name] = @lookup_group
      instance_eval(&block) if block
    end

    def option(name, id, display, data = {})
      @lookup_group.add_option(LookupOption.new(name, id, display, data))
    end

    def find_group(name)
      lookup_groups[name.to_sym]
    end

    def lookup_groups
      @lookup_groups ||= {}
    end

    def respond_to?(method, priv = false)
      return true if lookup_groups[method] || pluralized_name_match(method)
      super
    end

    def method_missing(sym, *args)
      group = lookup_groups[sym]
      return group.find_option_by_name(args[0]) if group && args.size == 1
      group = pluralized_name_match(sym)
      return group.options if group && args.size == 0
      super
    end

    def pluralized_name_match(sym)
      lookup_groups.each do |_key, g|
        return g if g.name.to_s.pluralize == sym.to_s
      end
      nil
    end
  end

  # LookupOption represents a single option for a column
  class LookupOption
    attr_reader :id, :name, :display, :data
    def initialize(name, id, display, data = {})
      @name = name
      @id = id
      @display = display
      @data = data
    end

    def to_s
      "id:#{id}, name:#{name}, display:#{display}"
    end

    def respond_to?(method, priv = false)
      data[method].present? || super
    end

    def method_missing(sym, *args)
      data[sym] || super
    end
  end

  # LookupGroup
  class LookupGroup
    attr_reader :name, :column, :options
    def initialize(name, column)
      @name = name
      @column = column
      @options = []
      @name_lookups = {}
      @id_lookups = {}
    end

    def add_option(option)
      options << option
      @name_lookups[option.name] = option
      @id_lookups[option.id] = option
    end

    def find_option_by_id(id)
      @id_lookups[id]
    end

    def find_option_by_name(name)
      @name_lookups[name]
    end
  end
end
