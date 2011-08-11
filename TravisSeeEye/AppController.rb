
class AppController < NSWindowController
  
  attr_accessor :statusMenu, :statusItem, :statusImage, :statusHighlightImage, :preferencesWindow
  
  def initialize
    @growl = Growl.new
  end
  
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
  end
  
  # Actions
  
  def helloWorld(sender)
    @growl.notify('notification', 'moin', 'moin moin')
  end

end