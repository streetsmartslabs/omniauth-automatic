require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Automatic < OmniAuth::Strategies::OAuth2
      option :name, "automatic"
      option :scope, 'scope:public scope:user:profile scope:location scope:vehicle:profile scope:vehicle:events scope:trip scope:behavior'

      option :client_options, {
        :site          => 'https://api.automatic.com',
        :authorize_url => 'https://accounts.automatic.com/oauth/authorize',
        :token_url     => 'https://accounts.automatic.com/oauth/access_token'
      }

      def authorize_params
        super.tap do |params|
          %w( scope ).each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
            end
          end
        end
      end

      def request_phase
        redirect(client.auth_code.authorize_url(authorize_params.merge(request.params)))
      end

      uid do
        user_params['user']['id'].to_s
      end

      info do
        {
          'id'         => raw_info['id'],
          'first_name' => raw_info['first_name'],
          'last_name'  => raw_info['last_name'],
          'email'      => raw_info['email'],
        }
      end

      def raw_info
        @raw_info ||= access_token.get(user_info_url).parsed
      end

      def user_params
        @user_params ||= access_token.params
      end

      def user_info_url
        "/user/%s/" % [user_params['user']['sid']]
      end

      protected
      def build_access_token
        verifier = request.params['code']
        client.auth_code.get_token(verifier, token_params.to_hash(:symbolize_keys => true), deep_symbolize(options.auth_token_params))
      end
    end
  end
end
