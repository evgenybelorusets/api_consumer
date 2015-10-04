require 'spec_helper'

RSpec.describe ExternalUser do
  context 'class methods' do
    subject { described_class }

    describe '#find_by_uid' do
      let(:user) { double :user }

      it 'should find first user with matching uid' do
        allow(subject).to receive(:find).with(:first, params: { uid: 'uid' }).and_return user
        expect(subject.find_by_uid('uid')).to eql user
      end
    end
  end
end