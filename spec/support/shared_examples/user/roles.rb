RSpec.shared_examples 'roles' do |name|
  method_name = "#{name}?"

  describe "##{method_name}" do
    it "should be true if role is #{name}" do
      allow(subject).to receive(:role).and_return name
      expect(subject.public_send method_name).to be_true
    end

    it "should be false if role is nit #{name}" do
      allow(subject).to receive(:role).and_return 'test'
      expect(subject.public_send method_name).to be_false
    end
  end
end
