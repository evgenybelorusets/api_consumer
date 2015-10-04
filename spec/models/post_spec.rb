require 'spec_helper'

RSpec.describe Post do
  before :each do
    allow(subject).to receive(:id).and_return 1
  end

  describe '#comments' do
    let(:comments) { double :comments }

    it 'should load comments for post' do
      allow(Comment).to receive(:find).with(:scope, params: { post_id: 1 }).and_return comments
      expect(subject.comments(:scope)).to eql comments
    end
  end

  describe '#new_comment' do
    let(:comment) { double :comment }

    it 'should return new comment with set post' do
      allow(Comment).to receive(:new).with(some: :attributes).and_return comment
      expect(comment).to receive(:post=).with(subject)
      expect(subject.new_comment(some: :attributes)).to eql comment
    end
  end

  describe '#new_comment' do
    let(:comment) { double :comment }

    it 'should look for comment with passed id and set post for it' do
      allow(subject).to receive(:comments).with(5).and_return comment
      expect(comment).to receive(:post=).with(subject)
      expect(subject.comment(5)).to eql comment
    end
  end
end