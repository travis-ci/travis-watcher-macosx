class PreferencesController
  
  attr_accessor :preferencesPanel, :reposTableView, :intervalInput, :remoteInput
  
  def initialize
    @preferences = Preferences.instance
    @repos = @preferences[:repos]
  end
  
  # Cocoa
  
  def awakeFromNib
    @reposTableView.dataSource = self
    #    @intervalInput.setIntegerValue(@preferences[:interval])
    #    @remoteInput.setStringValue(@preferences[:remote])
  end
  
  # Actions
  
  def addRepo(sender)
    @repos << 'travis-ci/travis-ci'

    @reposTableView.reloadData
  end
  
  def removeRepo(sender)
    if (index = @reposTableView.selectedRow) != -1
      @repos.delete_at(index)
      @reposTableView.reloadData
    end
  end
  
  def saveSettings(sender)
    @preferences[:repos] = @repos
    #    @preferences[:interval] = @intervalInput.integerValue
    #    @preferences[:remote] = @remoteInput.stringValue
    @preferencesPanel.performClose(self)
  end
  
  # Model
  
  def numberOfRowsInTableView(view)
    @repos.size
  end
  
  def tableView(view, objectValueForTableColumn:column, row:index)
    @repos[index]
  end
  
  def tableView(view, setObjectValue:object, forTableColumn:column, row:index)  
    @repos[index] = object
  end
  
end