import Cocoa

/*
    Base class for all subviews that alter the color scheme. Contains common logic (undo/redo, copy/paste, etc).
 */
class ColorSchemeViewController: NSViewController, NSMenuDelegate, ColorSchemesViewProtocol {
    
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var containerView: NSView!
    
    @IBOutlet weak var colorPickerContextMenu: NSMenu!
    @IBOutlet weak var pasteColorMenuItem: NSMenuItem!
    
    var history: ColorSchemeHistory!
    var clipboard: ColorClipboard!

    // Contains a mapping of control tag -> control. This is used to identify and update the control that is associated with a color change in the history.
    var controlsMap: [Int: NSControl] = [:]
    
    // Contains a mapping of control tag -> update action. This is used to identify and perform an update action associated with a color change in the history (eg. change the window background color and notify the system).
    var actionsMap: [Int: ColorChangeAction] = [:]
    
    // Identifies the color picker that most recently participated in a color clipboard copy operation (used to determine which color to copy to the clipboard). May be nil initially (when the panel is opened).
    var activeColorPicker: AuralColorPicker?
    
    var colorSchemeView: NSView {
        return self.view
    }
    
    override func viewDidLoad() {
        
        // Map all the controls that participate in making changes to the system color scheme, based on their tags, so that undo/redo operations can be performed on these controls later.
        for aView in containerView.subviews {
            
            // Only map the relevant controls (ignore NSTextField, etc)
            if let control = aView as? NSControl,
                control is AuralColorPicker || control is NSButton || control is NSStepper || control is GradientOptionsRadioButtonGroup {
                
                // Map the control to its tag
                controlsMap[control.tag] = control
                
                // Set the context menu for all color pickers so that clipboard operations may be performed on them.
                if let colorPicker = control as? AuralColorPicker {
                    
                    colorPicker.menu = colorPickerContextMenu
                    
                    // Whenever the context menu is invoked, note this color picker as the one that invoked the menu (used to determine which color picker is the source/target of a color clipboard copy/paste operation).
                    colorPicker.menuInvocationCallback = {(picker: AuralColorPicker) -> Void in self.activeColorPicker = picker}
                }
            }
        }
    }
    
    func resetFields(_ scheme: ColorScheme, _ history: ColorSchemeHistory, _ clipboard: ColorClipboard!) {
        
        self.history = history
        self.clipboard = clipboard
        
        // If the window is already visible, no need to scroll. Only scroll to top when the window is first opened.
        if !(self.view.window?.isVisible ?? false) {
            scrollToTop()
        }
    }
    
    // Scrolls the scroll view to the top
    func scrollToTop() {
        
        let contentView: NSClipView = scrollView.contentView
        contentView.scroll(NSMakePoint(0, contentView.documentView!.frame.height))
    }
    
    // If the last change that was made to the system color scheme was performed on a control in this view, then undo the change. Otherwise, do nothing.
    // The lastChange parameter contains information about the change, such as the control that was changed, and the associated control value.
    func undoChange(_ lastChange: ColorSchemeChange) -> Bool {
        
        // Check if the change is associated with a control in this view (by using the tag as an identifier)
        if let undoAction = actionsMap[lastChange.tag] {
            
            // Perform the undo operation on the relevant control, according to the control type
            
            if let colorPicker = controlsMap[lastChange.tag] as? NSColorWell, let undoColor = lastChange.undoValue as? NSColor {
                
                colorPicker.color = undoColor
                
            } else if let btnToggle = controlsMap[lastChange.tag] as? NSButton, let boolVal = lastChange.undoValue as? Bool {
                
                btnToggle.onIf(boolVal)
                
            } else if let btnGroup = controlsMap[lastChange.tag] as? GradientOptionsRadioButtonGroup, let gradientType = lastChange.undoValue as? GradientType {
                
                btnGroup.gradientType = gradientType
                
            } else if let stepper = controlsMap[lastChange.tag] as? NSStepper, let intVal = lastChange.undoValue as? Int {
                
                stepper.integerValue = intVal
            }
            
            // Perform the system update and notification action
            undoAction()
            
            // Let the caller know that this undo operation was successful.
            return true
        }

        // Let the caller know that this undo operation was unsuccessful, i.e. the change is not relevant to this view.
        return false
    }
    
    /* If the last undo operation that was performed on the system color scheme was performed on a control in this view, then redo the change.
     
        Otherwise, do nothing.
     
        The lastChange parameter contains information about the change, such as the control that was changed, and the associated control value.
     */
    func redoChange(_ lastChange: ColorSchemeChange) -> Bool {
        
        // Check if the change is associated with a control in this view (by using the tag as an identifier)
        if let redoAction = actionsMap[lastChange.tag] {
            
            // Perform the redo operation on the relevant control, according to the control type
            
            if let colorPicker = controlsMap[lastChange.tag] as? NSColorWell, let redoColor = lastChange.redoValue as? NSColor {
                
                colorPicker.color = redoColor
                
            } else if let btnToggle = controlsMap[lastChange.tag] as? NSButton, let boolVal = lastChange.redoValue as? Bool {
                
                btnToggle.onIf(boolVal)
                
            } else if let btnGroup = controlsMap[lastChange.tag] as? GradientOptionsRadioButtonGroup,
                let gradientType = lastChange.redoValue as? GradientType {
                    
                btnGroup.gradientType = gradientType
                
            } else if let stepper = controlsMap[lastChange.tag] as? NSStepper, let intVal = lastChange.redoValue as? Int {
                
                stepper.integerValue = intVal
            }
            
            // Perform the system update and notification action
            redoAction()
            
            // Let the caller know that this redo operation was successful.
            return true
        }
        
        // Let the caller know that this redo operation was unsuccessful, i.e. the change is not relevant to this view.
        return false
    }
    
    // Copies a color from the selected color picker to the color clipboard.
    @IBAction func copyColorAction(_ sender: Any) {
        
        if let picker = activeColorPicker {
            
            picker.copyToClipboard(clipboard)
            activeColorPicker = nil
        }
    }
    
    // Pastes a previously copied color from the color clipboard to a target color picker.
    @IBAction func pasteColorAction(_ sender: Any) {
        
        if let picker = activeColorPicker, let clipboardColor = clipboard.color {
            
            // Picker's current value is the undo (old) value, clipboard color is the redo (new) value.
            history.noteChange(picker.tag, picker.color, clipboardColor, .changeColor)
            
            // Paste color into the picker.
            picker.pasteFromClipboard(clipboard)
            
            // Perform the appropriate update/notification action.
            if let notifyAction = actionsMap[picker.tag] {
                notifyAction()
            }
            
            activeColorPicker = nil
        }
    }
    
    // MARK - MenuDelegate functions
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        
        // A paste can only be performed if the clipboard has a color copied to it.
        pasteColorMenuItem.enableIf(self.clipboard.hasColor)
    }
}
