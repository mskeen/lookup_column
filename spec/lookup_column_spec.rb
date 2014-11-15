require 'spec_helper'
# require 'sample_one'

describe LookupColumn do

  it 'allows setup of the columns' do
    class S1
      include LookupColumn
      lookup_group :status, :status_cd
    end

    expect(S1.lookup_groups.size).to eq 1
  end

end

# Usage for class SampleClass
# s = Sample.new
# s.status = SampleClass.status(:new)
# s.status
#    --> LookupOption::  id: :new, etc
