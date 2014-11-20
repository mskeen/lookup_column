require 'spec_helper'

# A sample class for working
class TestOne
  include LookupColumn

  attr_accessor :status_cd, :frequency_cd

  lookup_group :status, :status_cd do
    option :new,           1, 'New Order'
    option :in_progress,   2, 'In Progress'
    option :complete,      3, 'Complete'
  end

  lookup_group :frequency, :frequency_cd do
    option :daily,         1, 'Daily',  increment: 24
    option :weekly,        2, 'Weekly', increment: 24 * 7
  end
end

describe LookupColumn do

  describe 'Class Methods' do

    describe 'respond_to?' do
      it 'respond_to works for group names' do
        expect(TestOne.respond_to? :frequency).to eq true
        expect(TestOne.respond_to? :status).to eq true
      end

      it 'respond_to works for pluralized group names' do
        expect(TestOne.respond_to? :frequencies).to eq true
        expect(TestOne.respond_to? :statuses).to eq true
      end

      it 'respond_to still works when an unknown method is passed' do
        expect(TestOne.respond_to? :blah).to eq false
      end
    end

    describe 'lookup_groups' do
      it 'allows setup of the columns' do
        expect(TestOne.lookup_groups.size).to eq 2
      end

      it 'allows access to each lookup_group' do
        expect(TestOne.lookup_groups[:status].name).to eq :status
        expect(TestOne.lookup_groups[:status].column).to eq :status_cd
      end

      it 'allows access to each group''s options' do
        expect(TestOne.lookup_groups[:status].options.size).to eq 3
        expect(TestOne.lookup_groups[:frequency].options.size).to eq 2
      end
    end

    describe 'a method equal to the column name' do
      it 'returns an option using a class method with the group''s name' do
        expect(TestOne.status(:in_progress).name).to eq :in_progress
        expect(TestOne.status(:in_progress).id).to eq 2
        expect(TestOne.status(:in_progress).display).to eq 'In Progress'
      end
    end

    describe 'pluralized column name' do
      it 'returns a list of options' do
        expect(TestOne.frequencies.size).to eq 2
      end
    end
  end

  describe 'Instance Methods' do
    before(:each) do
      @sample = TestOne.new
    end

    it 'sets the column value when the LookupColumn is updated' do
      @sample.status = TestOne::status(:new)
      expect(@sample.status_cd).to eq 1
    end

    it 'allows setting the column''s code directly' do
      @sample.status_cd = 2
      expect(@sample.status).to eq TestOne::status(:in_progress)
    end

    it 'returns nil if the column hasn''t been set' do
      expect(@sample.status).to be_nil
    end

    it 'allows comparison to the class'' options' do
      @sample.status = TestOne::status(:in_progress)
      expect(@sample.status == TestOne::status(:in_progress)).to be true
    end

    it "allows access to extra data items" do
      @sample.frequency = TestOne::frequency(:weekly)
      expect(@sample.frequency.increment).to be 24*7
    end

    it "return NoMethodError if asking for a data item that doesn't exist" do
      @sample.frequency = TestOne::frequency(:weekly)
      expect { @sample.frequency.interval}.to raise_error(NoMethodError)
    end
  end

end
