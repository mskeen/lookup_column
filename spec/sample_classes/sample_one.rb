# A sample class for working
class SampleOne
  include LookupColumn

  attr_accessor :status_cd

  lookup_group :status, :status_cd do
    option :new,           1, 'New Order'
    option :in_progress,   2, 'In progress'
    option :complete,      3, 'New Order'
  end

  lookup_group :frequency, :frequency_cd do
    option :daily,         1, 'Daily',  increment: 24
    option :weekly,        2, 'Weekly', increment: 24 * 7
  end
end
