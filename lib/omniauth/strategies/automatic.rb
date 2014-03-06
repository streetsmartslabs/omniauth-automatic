require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Automatic < OmniAuth::Strategies::OAuth2
      option :name, "automatic"

      option :client_options, {
        :site          => 'https://api.automatic.com',
        :authorize_url => 'https://www.automatic.com/oauth/authorize',
        :token_url     => 'https://www.automatic.com/oauth/access_token'
      }

      option :scope, 'scope:location scope:vehicle scope:trip:summary scope:ignition:on scope:ignition:off scope:notification:speeding scope:notification:hard_brake scope:notification:hard_accel scope:region:changed scope:parking:changed scope:mil:on scope:mil:off'

      def authorize_params
        super.tap do |params|
          %w( scope client_options ).each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
            end
          end
        end
      end

      def request_phase
        redirect(client.auth_code.authorize_url(authorize_params.merge(request.params)))
      end

      uid { raw_info[:user][:id] }

      info do
        raw_info
      end

      extra do
        {
          :raw_info => raw_info
        }
      end

      def raw_info
        @raw_info ||= deep_symbolize(access_token.get.parsed)
      end

      def build_access_token
        headers = {
          :headers => {
            'Authorization' => ("bearer %s" % [client.secret])
          }
        }
        verifier = request.params['code']
        client.auth_code.get_token(verifier, token_params.to_hash(symbolize_keys: true).merge(headers))
      end
    end
  end
end
