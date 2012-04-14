require 'pp'

class Result
  
  def initialize(data)
    pp data
    @data = data
  end
  
  def name
    @data["repository"]["slug"]
  end
  
  def status
    @data["repository"]["last_build_status"]
  end
  
end