import Cocoa

class LayoutPreviewView: NSView {
    
    private var layout: WindowLayout?
    private let idealImgSize: CGFloat = 15
    
    private var screen: NSRect {
        return NSScreen.main!.frame
    }
    
    private var screenVisibleFrame: NSRect {
        return NSScreen.main!.visibleFrame
    }
    
    private var scale: CGFloat {
       return self.frame.width / screen.width
    }
    
    func drawPreviewForLayout(_ layout: WindowLayout) {
        self.layout = layout
        redraw()
    }
    
    func clear() {
        self.layout = nil
        redraw()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        let visibleFrame = screenVisibleFrame
        let drawRatio = scale
        
        // Draw screen
        var path = NSBezierPath.init(rect: dirtyRect)
        NSColor.darkGray.setFill()
        path.fill()
        
        let vx = visibleFrame.minX * drawRatio
        let vy = visibleFrame.minY * drawRatio
        let vw = visibleFrame.width * drawRatio
        let vh = visibleFrame.height * drawRatio
        
        // Draw visible frame
        let vRect = NSRect(x: vx, y: vy, width: vw, height: vh)
        path = NSBezierPath.init(rect: vRect)
        NSColor.white.setFill()
        path.fill()
        
        // Draw window frames
        if let layout = self.layout {
            
            let mainWindowFrame = WindowManager.mainWindowFrame
            renderPreview(layout.mainWindowOrigin, mainWindowFrame.width, mainWindowFrame.height, Images.imgPlayerPreview)
            
            if layout.showEffects {
                
                let effectsWindowFrame = WindowManager.effectsWindowFrame
                renderPreview(layout.effectsWindowOrigin!, effectsWindowFrame.width, effectsWindowFrame.height, Images.imgEffectsPreview)
            }
            
            if layout.showPlaylist {
                renderPreview(layout.playlistWindowFrame!, Images.imgPlaylistPreview)
            }
        }
    }
    
    private func renderPreview(_ origin: NSPoint, _ width: CGFloat, _ height: CGFloat, _ image: NSImage) {
        renderPreview(NSRect(x: origin.x, y: origin.y, width: width, height: height), image)
    }
    
    private func renderPreview(_ frame: NSRect, _ image: NSImage) {
        
        let drawRect = frame.shrink(scale)
        let path = NSBezierPath.init(roundedRect: drawRect, xRadius: 3, yRadius: 3)
        
        NSColor.black.setFill()
        path.fill()
        
        path.lineWidth = 2
        NSColor.lightGray.setStroke()
        path.stroke()
        
        let imgWidth = drawRect.width > (idealImgSize * 1.2) ? idealImgSize : idealImgSize * 0.67
        let imgHeight = drawRect.height > (idealImgSize * 1.2) ? idealImgSize : idealImgSize * 0.67
        
        let imgSize = min(imgWidth, imgHeight)
        
        let xPadding = drawRect.width - imgSize
        let yPadding = drawRect.height - imgSize
        
        let imgRect = NSRect(x: drawRect.minX + xPadding / 2, y: drawRect.minY + yPadding / 2, width: imgSize, height: imgSize)
        
        image.draw(in: imgRect)
    }
}

extension NSRect {
    
    func shrink(_ factor: CGFloat) -> NSRect {
        
        let nx = self.minX * factor
        let ny = self.minY * factor
        let nw = self.width * factor
        let nh = self.height * factor
        
        return NSRect(x: nx, y: ny, width: nw, height: nh)
    }
}
