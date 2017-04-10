class AdminController < ApplicationController
  layout 'admin'
  if ENV['ADMINPASSWORD']
    http_basic_authenticate_with name: "localwelcome", password: ENV['ADMINPASSWORD']
  end
end
