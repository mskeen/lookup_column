# A sample class for working
class SampleOne
  include LookupColumn

  lookup_group :status, :status_cd
  option :new, 1, 'New Order'
  option :in_progress, 2, 'In progress'
  option :new, 3, 'New Order'

  lookup_group :frequency, :frequency_cd
  option :daily, 1, 'Daily', increment: 24.hours
  option :weekly, 2, 'Weekly', increment: 1.week
end
