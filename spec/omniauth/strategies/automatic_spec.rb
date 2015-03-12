require 'ostruct'
require 'spec_helper'

describe OmniAuth::Strategies::Automatic do
  let(:access_token) { double('AccessToken', options: {}) }
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
      expect(subject.options.client_options.authorize_url).to eq('https://accounts.automatic.com/oauth/authorize')
    end

    it "returns the #token_url" do
      expect(subject.options.client_options.token_url).to eq('https://accounts.automatic.com/oauth/access_token')
    end
  end


  describe "auth params" do
    let(:response_params) do
      {
        'user' => {
          'id'         => '123',
          'sid'        => 'U_123'
        },
        'scope'         => 'scope:trip',
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
      access_token.stub(:expires_in).and_return(34345)
      access_token.stub(:expires_at).and_return(12345)
    end

    context "#raw_info" do
      it "should return user info" do
        access_token.should_receive(:get).with('/user/U_123/').and_return(response)
        subject.raw_info.should eq(parsed_response)
      end
    end

    it "builds the #user_info_url" do
      expect(subject.user_info_url).to eq('/user/U_123/')
    end

    it "returns the #user_params" do
      expected = {
        'user' => {
          'id'         => '123',
          'sid'        => 'U_123'
        },
        'scope'         => 'scope:trip',
        'access_token'  => '123',
        'refresh_token' => 'abcd',
        'expires_in'    => 34345,
        'token_type'    => 'Bearer'
      }
      expect(subject.user_params).to eq(expected)
    end

    it "returns the uid" do
      expected = '123'
      expect(subject.uid).to eq(expected)
    end

    describe "info hash" do
      let(:parsed_response) do
        {"id"=>"123", "first_name"=>"Lester", "last_name"=>"Tester", "email"=>"lester@example.com"}
      end

      it "returns the info hash" do
        expected = {
          'id'         => '123',
          'first_name' => 'Lester',
          'last_name'  => 'Tester',
          'email'      => 'lester@example.com'
        }
        access_token.should_receive(:get).with('/user/U_123/').and_return(response)
        expect(subject.info).to eq(expected)
      end
    end

    describe "auth hash" do
      let(:parsed_response) do
        {"provider"=>"automatic", "uid"=>"123", "info"=>{"id"=>"U_123", "first_name"=>"Lester", "last_name"=>"Tester", "email"=>"lester@example.com", "name"=>"Lester Tester"}, "credentials"=>{"token"=>"123", "refresh_token"=>"abcd", "expires_at"=>12345, "expires"=>true}, "extra"=>{}}
      end

      it "returns the auth hash" do
        expected = {"provider"=>"automatic", "uid"=>"123", "info"=>{"id"=>nil, "first_name"=>nil, "last_name"=>nil, "email"=>nil, "name"=>nil}, "credentials"=>{"token"=>"123", "refresh_token"=>"abcd", "expires_at"=>12345, "expires"=>true}, "extra"=>{}}
        access_token.should_receive(:get).with('/user/U_123/').and_return(response)
        expect(subject.auth_hash.to_hash).to eq(expected)
      end
    end

    it "returns the credentials hash" do
      expected = {
        'token'         => '123',
        'refresh_token' => 'abcd',
        'expires_at'    => 12345,
        'expires'       => true
      }
      expect(subject.credentials).to eq(expected)
    end
  end

  context "scope" do
    it "returns all scopes by default" do
      expect(subject.options['scope']).to eq('scope:public scope:user:profile scope:location scope:vehicle:profile scope:vehicle:events scope:trip scope:behavior')

    end

    it "allows you to override the scopes" do
      subject.options['scope'] = 'scope:location'
      expect(subject.options['scope']).to eq('scope:location')
    end
  end
end
