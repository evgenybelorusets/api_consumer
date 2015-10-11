RSpec.shared_examples 'external fields' do |name|
  method_name = "#{name}="

  describe "##{method_name}" do
    let(:external_user) { double :external_user }

    before :each do
      allow(subject).to receive(:uid).and_return 'value'
      allow(subject).to receive(:external_user).and_return external_user
    end

    it 'should set field for external actor and self' do
      expect(external_user).to receive(method_name).with('value')
      subject.public_send method_name, 'value'
      expect(subject.public_send name).to eql 'value'
    end
  end
end
