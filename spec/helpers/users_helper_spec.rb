require 'spec_helper'

describe UsersHelper do
  let(:user) { double :user, uid: 'uid' }

  describe '#destroy_post_link' do
    it 'should return destroy user link if user has ability' do
      allow(helper).to receive(:can?).with(:destroy, user).and_return true
      allow(helper).to receive(:user_path).with('uid').and_return 'path'
      allow(helper).to receive(:link_to).with('Delete user',
        'path',
        method: :delete,
        class: 'btn btn-danger',
        data: { confirm: 'Are you sure?', confirm_title: 'Delete' }).and_return 'link'
      expect(helper.destroy_user_link(user)).to eql 'link'
    end

    it 'should return nil if user has no ability' do
      allow(helper).to receive(:can?).with(:destroy, user).and_return false
      expect(helper.destroy_post_link(user)).to be_nil
    end
  end

  describe '#edit_user_link' do
    it 'should return edit user link if user has ability' do
      allow(helper).to receive(:can?).with(:update, user).and_return true
      allow(helper).to receive(:edit_user_path).with('uid').and_return 'path'
      allow(helper).to receive(:link_to).with('Edit user', 'path', class: 'btn btn-warning').and_return 'link'
      expect(helper.edit_user_link(user)).to eql 'link'
    end

    it 'should return nil if user has no ability' do
      allow(helper).to receive(:can?).with(:update, user).and_return false
      expect(helper.edit_user_link(user)).to be_nil
    end
  end
end