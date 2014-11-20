# Lookup Column

[![Build Status](https://travis-ci.org/mskeen/lookup_column.png?branch=master)](https://travis-ci.org/mskeen/lookup_column) [![Coverage Status](https://coveralls.io/repos/mskeen/lookup_column/badge.png?branch=master)](https://coveralls.io/r/mskeen/lookup_column?branch=master)

This is a ruby gem for conveniently handling lookup values for a field in an ActiveRecord model.

## Installation

Add this line to your application's Gemfile:

    gem 'lookup_column'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lookup_column

## Usage

As an example, let's assume you have a `Reminder` model that was created in the following migration:

    class CreateReminder < ActiveRecord::Migration
      def change
        create_table :reminders do |t|
          t.integer :user_id, null: false
          t.string :name, null: false
          t.string :description
          t.integer :status_cd
          t.integer :frequency_cd
          t.timestamps
        end
      end
    end

We would like the `status` and `frequency` fields to allow a specific set of values and we would like them to be stored in the database as simple integers. And in the case of `frequency`, we have an extra piece of data that we would like to have associated with each option: the interval of time between reminders.

Using the `lookup_column` gem, we can define the available options as follows:

    model Remider < ActiveRecord::Base
      include LookupColumn

      belongs_to :user
      
      lookup_group :status, :status_cd do
        option :new,           1, 'New'
        option :in_progress,   2, ''
        option :complete,      3, 'Complete'
      end
      
      lookup_group :frequency, :frequency_cd do
        option :daily,         1, 'Daily',   increment: 1.day
        option :weekly,        2, 'Weekly',  increment: 7.days
        option :monthly,       3, 'Monthly', increment: 1.month
        option :yearly,        4, 'Yearly',  increment: 1.year
      end
    end

### Setting Lookup Column Values

Set a column value:
 `reminder.frequency = Reminder.frequency(:new)`

This will update the `frequency_cd` field with the proper integer value.

### Comparing Lookup Column Values

Compare a column value:
`if reminder.frequency == Reminder.frequency(:new)`

### Get a List of the Available Options for a Column

  <%= form.select :ferquency_cd, Reminder.frequencies %>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
