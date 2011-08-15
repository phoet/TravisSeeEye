
class AppController
  
  attr_accessor :statusMenu, :statusItem, :statusImage, :reposStatusItem, :statusHighlightImage
  attr_accessor :preferencesPanel, :webPanel
  
  # Cocoa
  
  def awakeFromNib
    @statusItem = NSStatusBar.systemStatusBar.statusItemWithLength(NSSquareStatusItemLength)
        
    @statusImage = load_image('tci')
    @statusHighlightImage = load_image('tci-alt')
    
    @statusItem.setImage(@statusImage)
    @statusItem.setAlternateImage(@statusHighlightImage)
    
    @statusItem.setMenu(@statusMenu)
    @statusItem.setToolTip("Travis-CI")
    @statusItem.setHighlightMode(true)
    
    refreshResults(self)
  end
  
  # Menu Delegate
  
  def menu(menu, willHighlightItem:item)
    if item == @reposStatusItem
      item.submenu.removeAllItems()
      Preferences.instance[:repos].each do |repo|
        mi = NSMenuItem.new
        mi.title  = repo
        mi.action = 'showStatus:'
        mi.target = self
        mi.image  = load_build_image(repo)
        
        item.submenu.addItem(mi)
      end
    end
  end
  
  # Actions
  
  def showPreferences(sender)
    NSApp.activateIgnoringOtherApps(true)
    @preferencesPanel.makeKeyAndOrderFront(self)
  end
  
  def refreshResults(sender)
    Queue.instance.refresh_results(true)
  end
  
  def showStatus(sender)
    NSApp.activateIgnoringOtherApps(true)
    @webPanel.delegate.showBuild(Queue.instance.results[sender.title])
    @webPanel.makeKeyAndOrderFront(self)
  end

end