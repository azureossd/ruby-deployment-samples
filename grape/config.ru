require 'grape'

class API < Grape::API
  version 'v1', using: :header, vendor: 'azureossd'
  format :json
  prefix :api

  get :hello do
    { 'message' => 'Hello world from Grape!' }
  end
end
API.compile!
run API
