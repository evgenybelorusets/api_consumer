require 'spec_helper'

describe Concerns::Authorship do
  subject do
    Class.new do
      include Concerns::Authorship
    end.new
  end

  describe '#author_full_name_with_email' do
    before :each do
      allow(subject).to receive(:first_name).and_return 'First'
      allow(subject).to receive(:last_name).and_return 'Last'
      allow(subject).to receive(:email).and_return 'some@email.com'
    end

    it 'should return author full name with email' do
      expect(subject.author_full_name_with_email).to eql 'First Last <some@email.com>'
    end
  end
end