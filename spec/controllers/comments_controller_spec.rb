require 'spec_helper'

RSpec.describe CommentsController do
  let(:comment) { double :comment, id: 1, to_param: '1' }
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
      allow(subject).to receive(:comment).and_return comment
    end

    it 'should render response with 403 HTTP status if user has no ability to perform action' do
      allow(ability).to receive(:authorize!) { raise CanCan::AccessDenied }
      delete :destroy, id: 1, post_id: 2
      expect(response.status).to eql 403
    end

    it 'should destroy post and render response with 204 HTTP status' do
      expect(comment).to receive(:destroy)
      delete :destroy, id: 1, post_id: 2
      expect(response.status).to eql 204
    end
  end

  describe '#create' do
    before :each do
      allow(subject).to receive(:comment).and_return comment
    end

    it 'should render response with 403 HTTP if user has no ability to perform action' do
      allow(ability).to receive(:authorize!) { raise CanCan::AccessDenied }
      post :create, id: 1, post_id: 2
      expect(response.status).to eql 403
    end

    it 'should save comment with params and render :show in case of success' do
      allow(comment).to receive(:save).and_return true
      post :create, id: 1, post_id: 2
      expect(response).to render_template('show')
    end

    it 'should save comment with params and render response with 422 HTTP status' do
      allow(comment).to receive(:save).and_return false
      post :create, id: 1, post_id: 2
      expect(response.status).to eql 422
    end
  end

  describe '#update' do
    let(:comment_params) { double :comment_params }

    before :each do
      allow(subject).to receive(:comment_params).and_return comment_params
      allow(subject).to receive(:comment).and_return comment
    end

    it 'should render response with 403 HTTP if user has no ability to perform action' do
      allow(ability).to receive(:authorize!) { raise CanCan::AccessDenied }
      post :update, id: 1, post_id: 2
      expect(response.status).to eql 403
    end

    it 'should update comment with params and render :show in case of success' do
      allow(comment).to receive(:update_attributes).with(comment_params).and_return true
      post :update, id: 1, post_id: 2
      expect(response).to render_template('show')
    end

    it 'should update comment with params and render response with 422 HTTP status' do
      allow(comment).to receive(:update_attributes).with(comment_params).and_return false
      post :update, id: 1, post_id: 2
      expect(response.status).to eql 422
    end
  end

  describe '#edit' do
    it 'should render response with 403 HTTP if user has no ability to perform action' do
      allow(ability).to receive(:authorize!) { raise CanCan::AccessDenied }
      get :edit, id: 1, post_id: 2
      expect(response.status).to eql 403
    end

    it 'should render edit template' do
      get :edit, id: 1, post_id: 2
      expect(subject).to render_template('edit')
    end
  end

  describe '#edit' do
    it 'should render response with 403 HTTP if user has no ability to perform action' do
      allow(ability).to receive(:authorize!) { raise CanCan::AccessDenied }
      get :new, post_id: 2
      expect(response.status).to eql 403
    end

    it 'should render new template' do
      get :new, post_id: 2
      expect(subject).to render_template('new')
    end
  end

  describe '#index' do
    it 'should render response with 403 HTTP if post has no ability to perform action' do
      allow(ability).to receive(:authorize!) { raise CanCan::AccessDenied }
      get :index, post_id: 2
      expect(response.status).to eql 403
    end

    it 'should render index template' do
      get :index, post_id: 2
      expect(subject).to render_template('index')
    end
  end

  describe '#comment_params' do
    let(:params) { double :params }
    let(:required_params) { double :required_params }
    let(:permitted_params) { double :permitted_params }

    it 'should return only allowed params' do
      allow(subject).to receive(:params).and_return params
      allow(params).to receive(:require).with(:comment).and_return required_params
      allow(required_params).to receive(:permit).with(:content, :post_id).and_return permitted_params
      expect(subject.send :comment_params).to eql permitted_params
    end
  end

  describe '#post' do
    it 'should find post by id' do
      allow(subject).to receive(:params).and_return(post_id: 2)
      expect(Post).to receive(:find).with(2).once.and_return pst
      expect(subject.send :post).to eql pst
      expect(subject.send :post).to eql pst
    end
  end

  describe '#comment' do
    let(:comment_params) { double :comment_params }

    before :each do
      allow(subject).to receive(:post).and_return pst
      allow(subject).to receive(:comment_params).and_return comment_params
    end

    it 'should find comment by id' do
      allow(subject).to receive(:params).and_return(id: 2)
      expect(pst).to receive(:comment).with(2).once.and_return comment
      expect(subject.send :comment).to eql comment
      expect(subject.send :comment).to eql comment
    end

    it 'should return new comment if id is not present' do
      expect(pst).to receive(:new_comment).with(comment_params).once.and_return comment
      expect(subject.send :comment).to eql comment
      expect(subject.send :comment).to eql comment
    end
  end

  describe '#comments' do
    before :each do
      allow(subject).to receive(:post).and_return pst
    end

    it 'should return all post comments' do
      allow(pst).to receive(:comments).and_return [ comment ]
      expect(subject.send :comments).to eql [ comment ]
    end
  end
end