
class AppController
  
  attr_accessor :statusMenu, :statusItem, :statusImage, :statusHighlightImage
  attr_accessor :growl
  
  def applicationDidFinishLaunching(a_notification)
    # Insert code here to initialize your application
  end
  
  def awakeFromNib
    #Create the NSStatusBar and set its length
    @statusItem = NSStatusBar.systemStatusBar.statusItemWithLength(NSSquareStatusItemLength)
    
    #Used to detect where our files are
    bundle = NSBundle.mainBundle
    
    #Allocates and loads the images into the application which will be used for our NSStatusItem
    @statusImage = NSImage.alloc.initWithContentsOfFile(bundle.pathForResource("tci", ofType: "png"))
    @statusHighlightImage = NSImage.alloc.initWithContentsOfFile(bundle.pathForResource("tci-alt", ofType: "png"))
    
    #Sets the images in our NSStatusItem
    @statusItem.setImage(statusImage)
    @statusItem.setAlternateImage(statusHighlightImage)
    
    #Tells the NSStatusItem what menu to load
    @statusItem.setMenu(statusMenu)
    #Sets the tooptip for our item
    @statusItem.setToolTip("My Custom Menu Item")
    #Enables highlighting
    @statusItem.setHighlightMode(true)
    
    @growl = Growl.new('de.nofail.tci', ['notification'], NSImage.alloc.initWithContentsOfFile(bundle.pathForResource("tci", ofType: "png")))
  end
  
  def helloWorld(sender)
    @growl.notify('notification', 'moin', 'moin moin')
  end

end