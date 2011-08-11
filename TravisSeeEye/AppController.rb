
class AppController < NSWindowController
  
  attr_accessor :statusMenu, :statusItem, :statusImage, :statusHighlightImage, :preferencesWindow
  
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
  
  # Actions
  
  def refreshResults(sender)
    Queue.instance.refresh_results(nil)
  end

end