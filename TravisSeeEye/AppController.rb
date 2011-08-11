
class AppController < NSWindowController
  
  attr_accessor :statusMenu, :statusItem, :statusImage, :reposStatusItem, :statusHighlightImage, :preferencesWindow
  
  # Cocoa
  
  def awakeFromNib
    @statusItem = NSStatusBar.systemStatusBar.statusItemWithLength(NSSquareStatusItemLength)
    
    bundle = NSBundle.mainBundle
    
    @statusImage = NSImage.alloc.initWithContentsOfFile(bundle.pathForResource("tci", ofType: "png"))
    @statusHighlightImage = NSImage.alloc.initWithContentsOfFile(bundle.pathForResource("tci-alt", ofType: "png"))
    
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
        mi.title = repo
        mi.action = 'showStatus:'
        mi.target = self
        item.submenu.addItem(mi)
      end
    end
  end
  
  # Actions
  
  def refreshResults(sender)
    Queue.instance.refresh_results(nil)
  end
  
  def refreshRepso(sender)
    puts "repos #{Queue.instance.results}"
  end
  
  def showStatus(sender)
    alert = NSAlert.new
    alert.messageText = "Build result for #{sender.title}"
    alert.informativeText = Queue.instance.results[sender.title]
    alert.alertStyle = NSInformationalAlertStyle
    alert.addButtonWithTitle("close")
    response = alert.runModal
  end

end