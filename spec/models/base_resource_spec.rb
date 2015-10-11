require 'spec_helper'

RSpec.describe BaseResource do
  describe '#set_user_uid_prefix' do
    it 'should set user_uid prefix' do
      allow(described_class).to receive(:user_uid).and_return 'uid'
      subject.send :set_user_uid_prefix
      expect(subject.prefix_options).to eql(user_uid: 'uid')
    end
  end

  context 'class methods' do
    subject { described_class }

    describe '#user_uid' do
      before { Thread.current[:user_uid] = 'uid' }
      after { Thread.current[:user_uid] = nil }

      it 'should return user uid from thread' do
        expect(subject.user_uid).to eql 'uid'
      end
    end

    describe '#user_uid=' do
      after { Thread.current[:user_uid] = nil }

      it 'should set user_uid in thread' do
        subject.user_uid = 'uid'
        expect(subject.user_uid).to eql 'uid'
      end
    end
  end
end