import Cocoa

/*
    Window controller for the Chapters list window.
    Contains the Chapters list view and performs window snapping.
 */
class ChaptersListWindowController: NSWindowController, NotificationSubscriber {
    
    @IBOutlet weak var rootContainerBox: NSBox!
    
    override var windowNibName: String? {return "ChaptersList"}
    
    override func windowDidLoad() {
        
        self.window?.delegate = WindowManager.windowDelegate
        
        changeBackgroundColor(ColorSchemes.systemScheme.general.backgroundColor)
        
        Messenger.subscribe(self, .applyColorScheme, self.applyColorScheme(_:))
        Messenger.subscribe(self, .changeBackgroundColor, self.changeBackgroundColor(_:))
    }
    
    @IBAction func closeWindowAction(_ sender: AnyObject) {
        WindowManager.hideChaptersList()
    }
    
    private func applyColorScheme(_ scheme: ColorScheme) {
        changeBackgroundColor(scheme.general.backgroundColor)
    }
    
    private func changeBackgroundColor(_ color: NSColor) {
        rootContainerBox.fillColor = color
    }
}
