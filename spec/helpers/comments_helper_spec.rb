require 'spec_helper'

RSpec.describe CommentsHelper do
  let(:post) { double :post }
  let(:comment) { double :comment }

  before :each do
    allow(helper).to receive(:post).and_return post
  end

  describe '#destroy_comment_link' do
    it 'should return destroy comment link if user has ability' do
      allow(helper).to receive(:can?).with(:destroy, comment).and_return true
      allow(helper).to receive(:post_comment_path).with(post, comment).and_return 'path'
      allow(helper).to receive(:link_to).with('Delete comment',
        'path',
        method: :delete,
        class: 'btn btn-danger delete-comment',
        remote: true,
        data: { confirm: 'Are you sure?', confirm_title: 'Delete' }).and_return 'link'
      expect(helper.destroy_comment_link(comment)).to eql 'link'
    end

    it 'should return nil if user has no ability' do
      allow(helper).to receive(:can?).with(:destroy, comment).and_return false
      expect(helper.destroy_comment_link(comment)).to be_nil
    end
  end

  describe '#new_comment_link' do
    it 'should return destroy new link if user has ability' do
      allow(helper).to receive(:can?).with(:create, Comment).and_return true
      allow(helper).to receive(:new_post_comment_path).with(post).and_return 'path'
      allow(helper).to receive(:link_to).
        with('Add comment', 'path', class: 'btn btn-success new-comment', remote: true).
        and_return 'link'
      expect(helper.new_comment_link).to eql 'link'
    end

    it 'should return nil if user has no ability' do

      allow(helper).to receive(:can?).with(:create, Comment).and_return false
      expect(helper.new_comment_link).to be_nil
    end
  end

  describe '#edit_comment_link' do
    it 'should return edit comment link if user has ability' do
      allow(helper).to receive(:can?).with(:update, comment).and_return true
      allow(helper).to receive(:edit_post_comment_path).with(post, comment).and_return 'path'
      allow(helper).to receive(:link_to).
         with('Edit comment', 'path', class: 'btn btn-warning edit-comment', remote: true).
         and_return 'link'
      expect(helper.edit_comment_link(comment)).to eql 'link'
    end

    it 'should return nil if user has no ability' do
      allow(helper).to receive(:can?).with(:update, comment).and_return false
      expect(helper.edit_comment_link(comment)).to be_nil
    end
  end
end