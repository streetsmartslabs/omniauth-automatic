require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Automatic < OmniAuth::Strategies::OAuth2
      option :name, "automatic"
      option :scope, 'scope:public scope:user:profile scope:user:follow scope:location scope:current_location scope:vehicle:profile scope:vehicle:events scope:vehicle:vin scope:trip scope:behavior'

      option :client_options, {
        :site          => 'https://api.automatic.com',
        :authorize_url => 'https://accounts.automatic.com/oauth/authorize',
        :token_url     => 'https://accounts.automatic.com/oauth/access_token'
      }

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

      uid do
        raw_info[:user][:id].to_s
      end

      info do
        {
          'name' => raw_info[:user][:id]
        }
      end

      def raw_info
        @raw_info ||= deep_symbolize(access_token.params)
      end
    end
  end
end
