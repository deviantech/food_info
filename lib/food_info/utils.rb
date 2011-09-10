class String 
  def oauth_escape
    CGI.escape(self).gsub("%7E", "~").gsub("+", "%20") 
  end 
end
