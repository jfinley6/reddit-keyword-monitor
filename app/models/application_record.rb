class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  require 'httparty'
  require 'open-uri'
  
end
