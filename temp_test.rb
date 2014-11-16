# The main gem classes
module LookupColumn
  def self.included(base)
    # base is our target class. Invoke `extend` on it and pass nested module
    # with class methods.
    base.extend ClassMethods
  end

  def respond_to?(method, priv = false)
    self.class.lookup_groups[method].present? || super
  end

  def method_missing(sym, *args)
    group = self.class.lookup_groups[sym]
    if group
      group.find_option_by_code(send(group.column))
    else
      super
    end
  end

  # Class methods
  module ClassMethods
    def lookup_group(name, column, &block)
      @lookup_group = LookupGroup.new(name, column)
      lookup_groups[name] = @lookup_group
      instance_eval(&block) if block
    end

    def option(id, code, display, data = {})
      @lookup_group.add_option(LookupOption.new(id, code, display, data))
    end

    def lookup_groups
      @lookup_groups ||= {}
    end

    def respond_to?(method, priv = false)
      lookup_groups[method].present? || super
    end

    def method_missing(sym, *args)
      group = lookup_groups[sym]
      if group && args.size == 1
        group.find_option_by_id(args[0])
      else
        super
      end
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
      @code_lookups = {}
      @id_lookups = {}
    end

    def add_option(option)
      options << option
      @code_lookups[option.code] = option
      @id_lookups[option.id] = option
    end

    def find_option_by_code(code)
      @code_lookups[code]
    end

    def find_option_by_id(id)
      @id_lookups[id]
    end
  end
end

# A sample class for working
class SampleOne
  include LookupColumn

  attr_accessor :status_cd

  lookup_group :status, :status_cd do
    option :new, 1, 'New Order'
    option :in_progress, 2, 'In progress'
    option :complete, 3, 'New Order'
  end

  lookup_group :frequency, :frequency_cd do
    option :daily, 1, 'Daily', increment: 24
    option :weekly, 2, 'Weekly', increment: 24 * 7
  end
end

begin
  s = SampleOne.new
  puts SampleOne.lookup_groups.size
  puts SampleOne.lookup_groups[:status].name
  puts SampleOne::lookup_groups[:status].name
  s.status_cd = 1
  puts s.status.display
  puts '--'
  puts s.status
  puts SampleOne::status(:new)
  puts s.status == SampleOne::status(:new)
end
