require 'spec_helper'

describe OmniAuth::Strategies::Automatic do
  let(:access_token) { double('AccessToken', options: {}) }
  let(:parsed_response) { double('ParsedResponse') }
  let(:response) { double('Response', parsed: parsed_response) }

  subject { described_class.new({}) }

  before(:each) do
    subject.stub(:access_token).and_return(access_token)
  end

  context "client options" do
    it "returns the #site" do
      expect(subject.options.client_options.site).to eq('https://api.automatic.com')
    end

    it "returns the #authorize_url" do
      expect(subject.options.client_options.authorize_url).to eq('https://www.automatic.com/oauth/authorize')
    end

    it "returns the #token_url" do
      expect(subject.options.client_options.token_url).to eq('https://www.automatic.com/oauth/access_token')
    end
  end

  context "scope" do
    it "returns all scopes by default" do
      expect(subject.options['scope']).to eq('scope:location scope:vehicle scope:trip:summary scope:ignition:on scope:ignition:off scope:notification:speeding scope:notification:hard_brake scope:notification:hard_accel scope:region:changed scope:parking:changed scope:mil:on scope:mil:off')
    end

    it "allows you to override the scopes" do
      subject.options['scope'] = 'scope:location'
      expect(subject.options['scope']).to eq('scope:location')
    end
  end
end
