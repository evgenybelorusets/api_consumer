require 'spec_helper'

describe PostsHelper do
  let(:post) { double :post }

  describe '#destroy_post_link' do
    it 'should return destroy post link if user has ability' do
      allow(helper).to receive(:can?).with(:destroy, post).and_return true
      allow(helper).to receive(:post_path).with(post).and_return 'path'
      allow(helper).to receive(:link_to).with('Delete post',
        'path',
        method: :delete,
        class: 'btn btn-danger',
        data: { confirm: 'Are you sure?', confirm_title: 'Delete' }).and_return 'link'
      expect(helper.destroy_post_link(post)).to eql 'link'
    end

    it 'should return nil if user has no ability' do
      allow(helper).to receive(:can?).with(:destroy, post).and_return false
      expect(helper.destroy_post_link(post)).to be_nil
    end
  end

  describe '#edit_post_link' do
    it 'should return edit post link if user has ability' do
      allow(helper).to receive(:can?).with(:update, post).and_return true
      allow(helper).to receive(:edit_post_path).with(post).and_return 'path'
      allow(helper).to receive(:link_to).with('Edit post', 'path', class: 'btn btn-warning').and_return 'link'
      expect(helper.edit_post_link(post)).to eql 'link'
    end

    it 'should return nil if user has no ability' do
      allow(helper).to receive(:can?).with(:update, post).and_return false
      expect(helper.edit_post_link(post)).to be_nil
    end
  end

  describe '#post_link' do
    it 'should return post link if user has ability' do
      allow(helper).to receive(:can?).with(:read, post).and_return true
      allow(helper).to receive(:post_path).with(post).and_return 'path'
      allow(helper).to receive(:link_to).with('text', 'path', class: 'btn btn-info').and_return 'link'
      expect(helper.post_link(post, 'text')).to eql 'link'
    end

    it 'should return nil if user has no ability' do
      allow(helper).to receive(:can?).with(:read, post).and_return false
      expect(helper.post_link(post, 'text')).to be_nil
    end
  end
end