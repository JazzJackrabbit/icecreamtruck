def login(user)
  post '/api/v1/auth/sign_in', params:  { email: user.email, password: user.password }.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
end

def get_auth_params_from_login_response_headers(response)
  client = response.headers['client']
  token = response.headers['access-token']
  expiry = response.headers['expiry']
  token_type = response.headers['token-type']
  uid = response.headers['uid']

  auth_params = {
    'access-token' => token,
    'client' => client,
    'uid' => uid,
    'expiry' => expiry,
    'token-type' => token_type
  }
  auth_params
end

def create_auth_headers
  merchant = create :merchant
  login(merchant)
  auth_params = get_auth_params_from_login_response_headers(response)
  auth_params
end