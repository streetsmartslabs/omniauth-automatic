require 'ostruct'
require 'spec_helper'

describe OmniAuth::Strategies::Automatic do
  let(:access_token) { double('AccessToken', options: {}) }
  #let(:access_token) { double('AccessToken', OpenStruct.new(params: {})) }
  let(:parsed_response) { double('ParsedResponse') }
  let(:response) { double('Response', parsed: parsed_response) }
  let(:app) { lambda { |r| [200, '', ['Yo']] } }

  subject { described_class.new(app) }

  before(:each) do
    OmniAuth.config.test_mode = true
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

  describe "auth params" do
    let(:response_params) do
      {
        'user' => {
          'id' => '123'
        },
        'access_token'  => '123',
        'refresh_token' => 'abcd',
        'expires_in'    => 34345,
        'token_type'    => 'Bearer'
      }
    end

    before(:each) do
      access_token.stub(:params).and_return(response_params)
      access_token.stub(:token).and_return('123')
      access_token.stub(:expires?).and_return(true)
      access_token.stub(:refresh_token).and_return('abcd')
      access_token.stub(:expires_at).and_return(34345)
    end

    it "returns the uid" do
      expected = '123'
      expect(subject.uid).to eq(expected)
    end

    it "returns the info hash" do
      expected = {
        'name' => '123'
      }
      expect(subject.info).to eq(expected)
    end

    it "returns the auth hash" do
      expected = {"provider"=>"automatic", "uid"=>"123", "info"=>{"name"=>"123"}, "credentials"=>{"token"=>"123", "refresh_token"=>"abcd", "expires_at"=>34345, "expires"=>true}, "extra"=>{}}
      expect(subject.auth_hash.to_hash).to eq(expected)
    end

    it "returns the credentials hash" do
      expected = {
        'token'         => '123',
        'refresh_token' => 'abcd',
        'expires_at'    => 34345,
        'expires'       => true
      }
      expect(subject.credentials).to eq(expected)
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
