class AuthController < ApplicationController
  def index
    # If not go ahead and get one
    client_secrets = Google::APIClient::ClientSecrets.new Rails.application.config.google_drive_api_secret
    auth_client = client_secrets.to_authorization
    auth_client.update!(
        :scope => Google::Apis::DriveV3::AUTH_DRIVE,
        :redirect_uri => auth_index_url,
    )
    
    if request[:code].nil?
      session[:post_auth_redirect_uri] = params[:redirect] || root_path
      auth_uri = auth_client.authorization_uri.to_s
      redirect_to auth_uri
    else
      auth_client.code = request['code']
      auth_client.fetch_access_token!
      session[:google_drive_credential] = auth_client.to_json
      redirect_to session[:post_auth_redirect_uri] || root_path
      session.delete(:post_auth_redirect_uri)
    end
  end
end
