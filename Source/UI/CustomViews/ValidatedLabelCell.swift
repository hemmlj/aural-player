import Cocoa

class ValidatedLabelCell: NSTextFieldCell {
    
    var errorState: Bool = false
    
    func markError(_ errorString: String) {
        
        errorState = true
        textColor = NSColor.red
        self.stringValue = errorString
    }
    
    func clearError() {
        errorState = false
        self.stringValue = ""
        
        // TODO: Make this configurable/generic
        textColor = Colors.boxTextColor
    }
    
    override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
        
        super.draw(withFrame: cellFrame, in: controlView)
        
        if errorState {
            
            // Draw a red rectangular border around the cell, indicating an error state
            
            let rect = NSBezierPath(rect: cellFrame)
            rect.lineWidth = 3
            
            NSColor.red.setStroke()
            rect.stroke()
        }
    }
}
