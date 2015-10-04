require 'spec_helper'

RSpec.describe PostsController do
  let(:pst) { double :post, id: 1, to_param: '1' }
  let(:ability) { double :ability }

  before :each do
    allow(subject).to receive(:authenticate_user!)
    allow(subject).to receive(:set_user_uid)
    allow(subject).to receive(:current_ability).and_return ability
    allow(ability).to receive(:authorize!)
  end

  describe '#destroy' do
    before :each do
      allow(subject).to receive(:post).and_return pst
    end

    it 'should redirect to root if user has no ability to perform action' do
      allow(ability).to receive(:authorize!) { raise CanCan::AccessDenied }
      delete :destroy, id: 1
      expect(response).to redirect_to('http://test.host/')
    end

    it 'should destroy post and render index' do
      expect(pst).to receive(:destroy)
      delete :destroy, id: 1
      expect(subject).to render_template('index')
    end
  end

  describe '#create' do
    before :each do
      allow(subject).to receive(:post).and_return pst
    end

    it 'should redirect to root if user has no ability to perform action' do
      allow(ability).to receive(:authorize!) { raise CanCan::AccessDenied }
      post :create, id: 1
      expect(response).to redirect_to('http://test.host/')
    end

    it 'should save post with params and redirect to post in case of success' do
      allow(pst).to receive(:save).and_return true
      post :create, id: 1
      expect(response).to redirect_to('http://test.host/posts/1')
    end

    it 'should save post with params and render new form in case of failure' do
      allow(pst).to receive(:save).and_return false
      post :create, id: 1
      expect(subject).to render_template('new')
    end
  end

  describe '#update' do
    let(:post_params) { double :post_params }

    before :each do
      allow(subject).to receive(:post_params).and_return post_params
      allow(subject).to receive(:post).and_return pst
    end

    it 'should redirect to root if user has no ability to perform action' do
      allow(ability).to receive(:authorize!) { raise CanCan::AccessDenied }
      post :update, id: 1
      expect(response).to redirect_to('http://test.host/')
    end

    it 'should update post with params and redirect to post in case of success' do
      allow(pst).to receive(:update_attributes).with(post_params).and_return true
      post :update, id: 1
      expect(response).to redirect_to('http://test.host/posts/1')
    end

    it 'should update post with params and render edit form in case of failure' do
      allow(pst).to receive(:update_attributes).with(post_params).and_return false
      post :update, id: 1
      expect(subject).to render_template('edit')
    end
  end

  describe '#edit' do
    it 'should redirect to root if user has no ability to perform action' do
      allow(ability).to receive(:authorize!) { raise CanCan::AccessDenied }
      get :edit, id: 1
      expect(response).to redirect_to('http://test.host/')
    end

    it 'should render edit template' do
      get :edit, id: 1
      expect(subject).to render_template('edit')
    end
  end

  describe '#new' do
    it 'should redirect to root if user has no ability to perform action' do
      allow(ability).to receive(:authorize!) { raise CanCan::AccessDenied }
      get :new
      expect(response).to redirect_to('http://test.host/')
    end

    it 'should render new template' do
      get :new
      expect(subject).to render_template('new')
    end
  end

  describe '#index' do
    it 'should redirect to root if post has no ability to perform action' do
      allow(ability).to receive(:authorize!) { raise CanCan::AccessDenied }
      get :index
      expect(response).to redirect_to('http://test.host/')
    end

    it 'should render index template' do
      get :index
      expect(subject).to render_template('index')
    end
  end

  describe '#post_params' do
    let(:params) { double :params }
    let(:required_params) { double :required_params }
    let(:permitted_params) { double :permitted_params }

    it 'should return only allowed params' do
      allow(subject).to receive(:params).and_return params
      allow(params).to receive(:require).with(:post).and_return required_params
      allow(required_params).to receive(:permit).with(:title, :content).and_return permitted_params
      expect(subject.send :post_params).to eql permitted_params
    end
  end

  describe '#post' do
    let(:post_params) { double :post_params }

    before :each do
      allow(subject).to receive(:post_params).and_return post_params
    end

    it 'should find post by id if id present' do
      allow(subject).to receive(:params).and_return(id: 2)
      expect(Post).to receive(:find).with(2).once.and_return pst
      expect(subject.send :post).to eql pst
      expect(subject.send :post).to eql pst
    end

    it 'should return new post if id is not present' do
      expect(Post).to receive(:new).with(post_params).once.and_return pst
      expect(subject.send :post).to eql pst
      expect(subject.send :post).to eql pst
    end
  end

  describe '#posts' do
    it 'should return all posts' do
      allow(Post).to receive(:find).with(:all).and_return [ pst ]
      expect(subject.send :posts).to eql [ pst ]
    end
  end
end