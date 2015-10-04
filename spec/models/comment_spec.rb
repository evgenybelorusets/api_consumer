require 'spec_helper'

RSpec.describe Comment do
  let(:user) { double :user, uid: 'uid' }

  describe '#post=' do
    let(:post) { double :post, id: 12 }

    it 'should set post' do
      subject.post = post
      expect(subject.post).to eql post
    end

    it 'should set prefix options :post_id' do
      subject.post = post
      expect(subject.prefix_options[:post_id]).to eql 12
    end
  end

  describe '#post' do
    let(:post) { double :post }

    before :each do
      allow(subject).to receive(:prefix_options).and_return(post_id: 15)
    end

    it 'should find post by prefix option' do
      allow(Post).to receive(:find).with(15).once.and_return post
      expect(subject.post).to eql post
      expect(subject.post).to eql post
    end
  end
end