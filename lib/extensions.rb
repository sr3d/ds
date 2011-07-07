class String
  def extract_email
    self.scan(/(([a-z0-9_.-]+)@([a-z0-9-]+)\.[a-z.]+)/i).flatten.first
  end 
end