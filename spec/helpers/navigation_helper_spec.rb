require 'spec_helper'

describe NavigationHelper do
  describe '#nav_posts_link' do
    it 'should return posts link if user has ability' do
      allow(helper).to receive(:can?).with(:read, Post).and_return true
      allow(helper).to receive(:posts_path).and_return 'path'
      allow(helper).to receive(:link_to).with('All posts', 'path', class: 'btn nav-btn').and_return 'link'
      allow(helper).to receive(:content_tag).with(:li, 'link').and_return 'wrapped link'
      expect(helper.nav_posts_link).to eql 'wrapped link'
    end

    it 'should return nil if user has no ability' do
      allow(helper).to receive(:can?).with(:read, Post).and_return false
      expect(helper.nav_posts_link).to be_nil
    end
  end

  describe '#nav_new_post_link' do
    it 'should return new post link if user has ability' do
      allow(helper).to receive(:can?).with(:create, Post).and_return true
      allow(helper).to receive(:new_post_path).and_return 'path'
      allow(helper).to receive(:link_to).with('New post', 'path', class: 'btn nav-btn').and_return 'link'
      allow(helper).to receive(:content_tag).with(:li, 'link').and_return 'wrapped link'
      expect(helper.nav_new_post_link).to eql 'wrapped link'
    end

    it 'should return nil if user has no ability' do
      allow(helper).to receive(:can?).with(:create, Post).and_return false
      expect(helper.nav_new_post_link).to be_nil
    end
  end

  describe '#nav_users_link' do
    it 'should return users link if user has ability' do
      allow(helper).to receive(:can?).with(:read, User).and_return true
      allow(helper).to receive(:users_path).and_return 'path'
      allow(helper).to receive(:link_to).with('Users', 'path', class: 'btn nav-btn').and_return 'link'
      allow(helper).to receive(:content_tag).with(:li, 'link').and_return 'wrapped link'
      expect(helper.nav_users_link).to eql 'wrapped link'
    end

    it 'should return nil if user has no ability' do
      allow(helper).to receive(:can?).with(:read, User).and_return false
      expect(helper.nav_users_link).to be_nil
    end
  end

  describe '#nav_profile_link' do
    it 'should return edit user link if user is signed in' do
      allow(helper).to receive(:signed_in?).and_return true
      allow(helper).to receive(:edit_user_registration_path).and_return 'path'
      allow(helper).to receive(:link_to).with('Profile', 'path', class: 'btn nav-btn').and_return 'link'
      allow(helper).to receive(:content_tag).with(:li, 'link').and_return 'wrapped link'
      expect(helper.nav_profile_link).to eql 'wrapped link'
    end

    it 'should return nil if user is not signed in' do
      allow(helper).to receive(:signed_in?).and_return false
      expect(helper.nav_profile_link).to be_nil
    end
  end

  describe '#nav_sign_in_or_out_link' do
    before :each do
      allow(helper).to receive(:content_tag).with(:li).and_yield
    end

    it 'should return sign out link if user is signed in' do
      allow(helper).to receive(:signed_in?).and_return true
      allow(helper).to receive(:destroy_user_session_path).and_return 'path'
      allow(helper).to receive(:link_to).
        with('Sign out', 'path', class: 'btn nav-btn', method: :delete).and_return 'link'
      expect(helper.nav_sign_in_or_out_link).to eql 'link'
    end

    it 'should return sign in link if users is signed out' do
      allow(helper).to receive(:signed_in?).and_return false
      allow(helper).to receive(:user_session_path).and_return 'path'
      allow(helper).to receive(:link_to).with('Sign in', 'path', class: 'btn nav-btn').and_return 'link'
      expect(helper.nav_sign_in_or_out_link).to eql 'link'
    end
  end
end