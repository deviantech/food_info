require 'base64'
require 'hmac-sha1'

module FoodInfo

  class Request
    KEY = ENV['KEY']
    SECRET = ENV['SECRET']
    @@host = 'http://platform.fatsecret.com/rest/server.api'
    @@format = 'json'
  
    def initialize(method, optional_params = {})
      @request_nonce = (0...10).map{65.+(rand(25)).chr}.join
      @request_time  = Time.now.to_i.to_s
      @http_method   = optional_params.delete(:http_method) || 'GET'

      @params = {
        :method => method,
        :format => @@format
      }.merge(optional_params || {})
    end
  
    def signed_request
      "#{@@host}?#{make_query_string(query_params)}&oauth_signature=#{request_signature}"
    end

        
    protected

    def request_signature(token=nil)
      signing_key  = [SECRET, token].join('&')
    
      sha = HMAC::SHA1.digest(signing_key, signature_base_string)
      Base64.encode64(sha).strip.oauth_escape
    end

    def signature_base_string
      [@http_method, @@host, make_query_string(query_params)].map(&:oauth_escape).join('&')
    end
  
    def make_query_string(pairs)
      sorted = pairs.sort{|a,b| a[0].to_s <=> b[0].to_s}
      sorted.collect{|p| p.join('=')}.join('&')
    end
  
    def query_params
      oauth_components.merge(@params)
    end
      
    def oauth_components
      {
        :oauth_consumer_key => KEY,
        :oauth_signature_method => 'HMAC-SHA1',
        :oauth_timestamp => @request_time,
        :oauth_nonce => @request_nonce,
        :oauth_version => '1.0'
      }
    end

  end
  
end