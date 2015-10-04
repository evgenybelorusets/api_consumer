require 'spec_helper'

RSpec.describe Ability do
  let(:user) { User.new id: 1 }
  subject { Ability.new user }

  before :each do
    allow(user).to receive(:external_user_id).and_return 1
    allow(user).to receive(:user?).and_return false
    allow(user).to receive(:admin?).and_return false
  end

  context 'any user permissions' do
    it { expect(subject.can? :read, User).to be_false }
    it { expect(subject.can? :read, Post).to be_true }
    it { expect(subject.can? :read, Comment).to be_true }
    it { expect(subject.can? :create, User).to be_false }
    it { expect(subject.can? :create, Post).to be_false }
    it { expect(subject.can? :create, Comment).to be_false }
    it { expect(subject.can? :update, User).to be_false }
    it { expect(subject.can? :update, Post).to be_false }
    it { expect(subject.can? :update, Comment).to be_false }
    it { expect(subject.can? :destroy, User).to be_false }
    it { expect(subject.can? :destroy, Post).to be_false }
    it { expect(subject.can? :destroy, Comment).to be_false }
  end

  context 'user permissions' do
    before :each do
      allow(user).to receive(:user?).and_return true
    end

    let(:different_user) { User.new id: 2 }
    let(:post1) { Post.new user_id: 1 }
    let(:comment1) { Comment.new user_id: 1 }
    let(:post2) { Post.new user_id: 2 }
    let(:comment2) { Comment.new user_id: 2 }

    it { expect(subject.can? :read, Post).to be_true }
    it { expect(subject.can? :read, Comment).to be_true }
    it { expect(subject.can? :create, User).to be_false }
    it { expect(subject.can? :create, Post).to be_true }
    it { expect(subject.can? :create, Comment).to be_true }
    it { expect(subject.can? :update, post1).to be_true }
    it { expect(subject.can? :update, post2).to be_false }
    it { expect(subject.can? :update, comment1).to be_true }
    it { expect(subject.can? :update, comment2).to be_false }
    it { expect(subject.can? :destroy, User).to be_false }
    it { expect(subject.can? :destroy, post1).to be_true }
    it { expect(subject.can? :destroy, post2).to be_false }
    it { expect(subject.can? :destroy, comment1).to be_true }
    it { expect(subject.can? :destroy, comment2).to be_false }
  end

  context 'admin permissions' do
    before :each do
      allow(user).to receive(:admin?).and_return true
    end

    it { expect(subject.can? :read, User).to be_true }
    it { expect(subject.can? :read, Post).to be_true }
    it { expect(subject.can? :read, Comment).to be_true }
    it { expect(subject.can? :create, User).to be_true }
    it { expect(subject.can? :create, Post).to be_true }
    it { expect(subject.can? :create, Comment).to be_true }
    it { expect(subject.can? :update, User).to be_true }
    it { expect(subject.can? :update, Post).to be_true }
    it { expect(subject.can? :update, Comment).to be_true }
    it { expect(subject.can? :destroy, User).to be_true }
    it { expect(subject.can? :destroy, Post).to be_true }
    it { expect(subject.can? :destroy, Comment).to be_true }
  end
end