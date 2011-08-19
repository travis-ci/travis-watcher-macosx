class Result
  
  def initialize(data)
    pp data
    @data = data
  end
  
  def name
    event.data["repository"]["slug"]
  end
  
  def status
    event.data["repository"]["last_build_status"]
  end
  
end