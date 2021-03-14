import Cocoa

class ViewPreferencesViewController: NSViewController, PreferencesViewProtocol {
    
    @IBOutlet weak var btnStartWithLayout: NSButton!
    @IBOutlet weak var btnRememberLayout: NSButton!
    @IBOutlet weak var layoutMenu: NSPopUpButton!
    
    @IBOutlet weak var btnSnapToWindows: NSButton!
    @IBOutlet weak var lblWindowGap: NSTextField!
    @IBOutlet weak var gapStepper: NSStepper!
    
    @IBOutlet weak var btnSnapToScreen: NSButton!
    
    override var nibName: String? {return "ViewPreferences"}
    
    var preferencesView: NSView {
        return self.view
    }
    
    func resetFields(_ preferences: Preferences) {
        
        let viewPrefs = preferences.viewPreferences
     
        if (viewPrefs.layoutOnStartup.option == .specific) {
            btnStartWithLayout.on()
        } else {
            btnRememberLayout.on()
        }
        
        updateLayoutMenu()
        
        if let item = layoutMenu.item(withTitle: viewPrefs.layoutOnStartup.layoutName) {
            layoutMenu.select(item)
        } else {
            // Default
            layoutMenu.select(layoutMenu.item(withTitle: WindowLayouts.defaultLayout.name))
        }
        layoutMenu.enableIf(btnStartWithLayout.isOn)
        
        btnSnapToWindows.onIf(viewPrefs.snapToWindows)
        gapStepper.floatValue = viewPrefs.windowGap
        lblWindowGap.stringValue = ValueFormatter.formatPixels(gapStepper.floatValue)
        [lblWindowGap, gapStepper].forEach({$0!.enableIf(btnSnapToWindows.isOn)})
        
        btnSnapToScreen.onIf(viewPrefs.snapToScreen)
    }
    
    // Update the layout menu with custom layouts
    private func updateLayoutMenu() {
        
        // Recreate the custom layout items
        let itemCount = layoutMenu.itemArray.count
        
        let customLayoutCount = itemCount - 9  // 1 separator, 8 presets
        
        if customLayoutCount > 0 {
            
            // Need to traverse in descending order because items are going to be removed
            for index in (0..<customLayoutCount).reversed() {
                layoutMenu.removeItem(at: index)
            }
        }
        
        // Reinsert the custom layouts
        WindowLayouts.userDefinedLayouts.forEach({
            self.layoutMenu.insertItem(withTitle: $0.name, at: 0)
        })
    }
    
    @IBAction func layoutOnStartupAction(_ sender: Any) {
        layoutMenu.enableIf(btnStartWithLayout.isOn)
    }
    
    @IBAction func snapToWindowsAction(_ sender: Any) {
        [lblWindowGap, gapStepper].forEach({$0!.enableIf(btnSnapToWindows.isOn)})
    }
    
    @IBAction func gapStepperAction(_ sender: Any) {
        lblWindowGap.stringValue = ValueFormatter.formatPixels(gapStepper.floatValue)
    }

    func save(_ preferences: Preferences) throws {
        
        let viewPrefs = preferences.viewPreferences
        
        viewPrefs.layoutOnStartup.option = btnStartWithLayout.isOn ? .specific : .rememberFromLastAppLaunch
        viewPrefs.layoutOnStartup.layoutName = layoutMenu.selectedItem!.title
        
        viewPrefs.snapToWindows = btnSnapToWindows.isOn
        
        let oldWindowGap = viewPrefs.windowGap
        viewPrefs.windowGap = gapStepper.floatValue
        
        // Check if window gap was changed
        if (viewPrefs.windowGap != oldWindowGap) {
            
            // Recompute system-defined layouts based on new gap between windows
            WindowLayouts.recomputeSystemDefinedLayouts()
        }
        
        viewPrefs.snapToScreen = btnSnapToScreen.isOn
    }
}
