require 'spec_helper'

describe ApplicationController do
  context 'filters' do
    it { should use_before_filter :authenticate_user! }
    it { should use_before_filter :configure_permitted_parameters }
    it { should use_before_filter :set_user_uid }
  end

  describe '#set_user_uid' do
    let(:user) { double :current_user, uid: 'qwe' }

    it 'should set current user uid as prefix to resources' do
      allow(subject).to receive(:current_user).and_return user
      expect(BaseResource).to receive(:user_uid=).with 'qwe'
      subject.send :set_user_uid
    end
  end
end