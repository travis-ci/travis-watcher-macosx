class PreferencesController
  
  attr_accessor :preferencesPanel, :reposTableView
  
  def initialize
    @preferences = Preferences.instance
    @repos = @preferences[:repos]
  end
  
  # Cocoa
  
  def awakeFromNib
    @reposTableView.dataSource = self
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