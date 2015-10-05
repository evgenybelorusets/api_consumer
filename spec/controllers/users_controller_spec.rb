require 'spec_helper'

RSpec.describe UsersController do
  let(:user) { double :user }
  let(:ability) { double :ability }

  before :each do
    allow(subject).to receive(:authenticate_user!)
    allow(subject).to receive(:set_user_uid)
    allow(subject).to receive(:current_ability).and_return ability
    allow(ability).to receive(:authorize!)
  end

  describe '#destroy' do
    before :each do
      allow(subject).to receive(:user).and_return user
    end

    it 'should redirect to root if user has no ability to perform action' do
      allow(ability).to receive(:authorize!) { raise CanCan::AccessDenied }
      delete :destroy, id: 'uid'
      expect(response).to redirect_to('http://test.host/')
    end

    it 'should destroy user and render index' do
      expect(user).to receive(:destroy)
      delete :destroy, id: 'uid'
      expect(response).to redirect_to('http://test.host/users')
    end
  end

  describe '#update' do
    let(:user_params) { double :user_params }

    before :each do
      allow(subject).to receive(:user_params).and_return user_params
      allow(subject).to receive(:user).and_return user
    end

    it 'should redirect to root if user has no ability to perform action' do
      allow(ability).to receive(:authorize!) { raise CanCan::AccessDenied }
      post :update, id: 'uid'
      expect(response).to redirect_to('http://test.host/')
    end

    it 'should update user with params and redirect to users in case of success' do
      allow(user).to receive(:update_attributes).with(user_params).and_return true
      post :update, id: 'uid'
      expect(response).to redirect_to('http://test.host/users')
    end

    it 'should update user with params and render edit form in case of failure' do
      allow(user).to receive(:update_attributes).with(user_params).and_return false
      post :update, id: 'uid'
      expect(subject).to render_template('edit')
    end
  end

  describe '#edit' do
    it 'should redirect to root if user has no ability to perform action' do
      allow(ability).to receive(:authorize!) { raise CanCan::AccessDenied }
      get :edit, id: 'uid'
      expect(response).to redirect_to('http://test.host/')
    end

    it 'should render edit template' do
      get :edit, id: 'uid'
      expect(subject).to render_template('edit')
    end
  end

  describe '#index' do
    it 'should redirect to root if user has no ability to perform action' do
      allow(ability).to receive(:authorize!) { raise CanCan::AccessDenied }
      get :index
      expect(response).to redirect_to('http://test.host/')
    end

    it 'should render index template' do
      get :index
      expect(subject).to render_template('index')
    end
  end

  describe '#user_params' do
    let(:params) { double :params }
    let(:required_params) { double :required_params }
    let(:permitted_params) { double :permitted_params }

    it 'should return only allowed params' do
      allow(subject).to receive(:params).and_return params
      allow(params).to receive(:require).with(:user).and_return required_params
      allow(required_params).to receive(:permit).with(:email, :first_name, :last_name).and_return permitted_params
      expect(subject.send :user_params).to eql permitted_params
    end
  end

  describe '#user' do
    it 'should find user by uid' do
      allow(subject).to receive(:params).and_return(id: 'uid')
      allow(User).to receive(:find_by_uid).with('uid').once.and_return user
      expect(subject.send :user).to eql user
      expect(subject.send :user).to eql user
    end
  end

  describe '#users' do
    it 'should return all users paged' do
      allow(subject).to receive(:params).and_return(page: 2)
      allow(User).to receive(:page).with(2).and_return [ user ]
      expect(subject.send :users).to eql [ user ]
    end
  end
end