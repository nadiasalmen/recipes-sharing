# frozen_string_literal: true

module RequestSpecHelper
  def json
    JSON.parse(response.body)
  end

  def encoded_token(user)
    secret = Rails.application.credentials.devise_jwt_secret_key!
    payload = { sub: user.id, jti: user.jti, scp: "api_v1_user", exp: 1.day.from_now.to_i }
    JWT.encode(payload, secret, 'HS256')
  end

  def headers(user)
    token = encoded_token(user)
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{token}"
    }
  end
end

# decoded_token = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!, true, { algorithm: 'HS256' })
# decoded_token[0]['sub']
# request.headers['Authorization'].split(' ').last
