require 'spec_helper'

RSpec.describe User do
  context 'read only attributes' do
    it { expect(described_class._attr_readonly).to include 'uid' }
  end

  context 'delegated methods' do
    it { expect(subject).to respond_to(:first_name) }
    it { expect(subject).to respond_to(:last_name) }
    it { expect(subject).to respond_to(:role) }
    it { expect(subject).to respond_to(:first_name=) }
    it { expect(subject).to respond_to(:last_name=) }
    it { expect(subject).to respond_to(:role=) }
    it { expect(subject).to respond_to(:external_user_id) }
  end

  it_behaves_like 'roles', 'user'
  it_behaves_like 'roles', 'admin'

  it_behaves_like 'external fields', 'email'
  it_behaves_like 'external fields', 'uid'

  context 'callbacks', slow: true do
    let(:user) { build :user }

    describe '#before_create' do
      it 'should call #generate_uid_and_create_external_use on create' do
        expect(user).to receive(:generate_uid_and_create_external_user)
        user.save
      end
    end

    describe '#before_save' do
      before :each do
        allow(user).to receive(:generate_uid_and_create_external_user)
      end

      it 'should save external user if object is not new record' do
        user.save
        expect(user).to receive(:save_external).once
        user.save
      end

      it 'should not save external user if object is new record' do
        user.save
        expect(user).not_to receive(:save_external)
      end
    end

    describe '#before_destroy' do
      before :each do
        allow(user).to receive(:generate_uid_and_create_external_user)
        allow(user).to receive(:save_external)
      end

      it 'should destroy external' do
        user.save
        expect(user).to receive(:destroy_external)
        user.destroy
      end
    end
  end

  describe '#save_external' do
    let(:external_user) { double :external_user }

    before :each do
      allow(subject).to receive(:external_user).and_return external_user
    end

    it 'should save external user' do
      expect(external_user).to receive(:save!)
      subject.send :save_external
    end
  end

  describe '#destroy_external' do
    let(:external_user) { double :external_user }

    before :each do
      allow(subject).to receive(:external_user).and_return external_user
    end

    it 'should destroy external user' do
      expect(external_user).to receive(:destroy)
      subject.send :destroy_external
    end
  end

  describe '#reload_external_user' do
    it 'should call external user with force = true' do
      expect(subject).to receive(:external_user).with(true)
      subject.send :reload_external_user
    end
  end

  describe '#external_user_key' do
    it 'should return cache key for external user' do
      subject.id = 12
      expect(subject.send :external_user_key).to eql 'external_user_12'
    end
  end

  describe '#external_user' do
    let(:cache) { double :cache }
    let(:new_user) { double :new_user }
    let(:old_user) { double :old_user }

    before :each do
      allow(subject).to receive(:uid).and_return 'uid'
      allow(Rails).to receive(:cache).and_return cache
      allow(cache).to receive(:delete)
      allow(cache).to receive(:fetch)
      allow(subject).to receive(:external_user_key).and_return 'key'
      allow(ExternalUser).to receive(:new).with(role: 'user').and_return new_user
      allow(ExternalUser).to receive(:find_by_uid).with('uid').and_return old_user
    end

    it 'should delete data form cache if force = true' do
      expect(cache).to receive(:delete).with 'key'
      subject.send :external_user, true
    end

    it 'should return new user if new record' do
      allow(subject).to receive(:new_record?).and_return true
      expect(subject.send :external_user).to eql new_user
    end

    it 'should return and cache old user if not new record' do
      allow(subject).to receive(:new_record?).and_return false
      expect(cache).to receive(:fetch).with('key').and_yield
      expect(subject.send :external_user).to eql old_user
    end
  end

  describe '#generate_uid_and_create_external_user' do
    let(:external_user) { double :external_user }
    let(:scope_with_matches) { double :score_with_matches, exists?: true }
    let(:scope_without_matches) { double :score_without_matches, exists?: false }

    before :each do
      allow(subject).to receive(:guest?).and_return false
      allow(subject).to receive(:external_user).and_return external_user
      allow(User).to receive(:where).and_return scope_without_matches
      allow(subject).to receive(:uid=)
      allow(subject).to receive(:save_external)
      allow(SecureRandom).to receive(:hex)
    end

    it 'should generate uid while not uniq' do
      allow(SecureRandom).to receive(:hex).with(16).and_return 'uid1'
      allow(User).to receive(:where).with(uid: 'uid1').and_return scope_with_matches
      allow(SecureRandom).to receive(:hex).with(16).and_return 'uid2'
      allow(User).to receive(:where).with(uid: 'uid2').and_return scope_without_matches
      expect(subject).to receive(:uid=).with 'uid2'
      subject.send :generate_uid_and_create_external_user
    end

    it 'should save external user' do
      expect(subject).to receive(:save_external)
      subject.send :generate_uid_and_create_external_user
    end
  end
end