require "lookup_column/version"

module LookupColumn
  attr_reader :enum_columns

  def ecode(name, column)
    @enum_columns = [] if !@enum_columns
    @enum_column = EnumColumn.new(name, column)
    enum_columns << @enum_column
  end

  def option(id, code, display, data = {})
    @enum_column.add_option(EnumOption.new(id, code, display, data))
  end

  def respond_to?(method, priv = false)
    method_names = enum_columns.map { |c| c.name.to_s }
    (method_names.include? method.to_s) || super
  end

  def method_missing(sym, *args)
    method_names = enum_columns.map { |c| c.name.to_s }
    if method_namesym.to_s =~ /^is_a_(\w+)$/
      pattern = $1
      # then just do something with pattern here, e.g.:
      # puts pattern
    else
      super
    end
  end

  private

  class EnumOption
    attr_reader :id, :code, :display, :data
    def initialize(id, code, display, data = {})
      @id = id
      @code = code
      @display = display
      @data = data
    end
  end

  class EnumColumn
    attr_reader :name, :column, :options
    def initialize(name, column)
      @name = name
      @options = []
    end

    def add_option(option)
      @options << option
    end
  end

end
