class ApplicationApi < Grape::API
  format :json

  version 'v1'
  extend Napa::GrapeExtenders

  add_swagger_documentation api_version: 'v1', hide_documentation_path: true
end
