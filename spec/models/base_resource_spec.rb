require 'spec_helper'

RSpec.describe BaseResource do
  let(:user) { double :user, uid: 'uid' }

  describe '#full_name' do
    it 'should return full name of resource owner' do
      subject.first_name = 'First'
      subject.last_name = 'Last'
      subject.email = 'first.last@example.com'
      expect(subject.full_name).to eql 'First Last <first.last@example.com>'
    end
  end
end