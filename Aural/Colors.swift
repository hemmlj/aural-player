/*
    Container for colors used by the UI
*/

import Cocoa

struct ColorConstants {
    
    static let white10Percent: NSColor = NSColor(calibratedWhite: 0.1, alpha: 1)
    static let white40Percent: NSColor = NSColor(calibratedWhite: 0.4, alpha: 1)
    static let white45Percent: NSColor = NSColor(calibratedWhite: 0.45, alpha: 1)
    static let white50Percent: NSColor = NSColor(calibratedWhite: 0.5, alpha: 1)
    static let white60Percent: NSColor = NSColor(calibratedWhite: 0.6, alpha: 1)
    static let white70Percent: NSColor = NSColor(calibratedWhite: 0.7, alpha: 1)
    static let white80Percent: NSColor = NSColor(calibratedWhite: 0.8, alpha: 1)
    static let white85Percent: NSColor = NSColor(calibratedWhite: 0.85, alpha: 1)
    static let white90Percent: NSColor = NSColor(calibratedWhite: 0.9, alpha: 1)
}

enum ColorScheme {

    case darkBackground_lightText
    case lightBackground_darkText
    
}

struct Colors {
    
    static var scheme: ColorScheme = .lightBackground_darkText
    
    struct Player {
        
        static var titleColor: NSColor {
            
            switch Colors.scheme {
                
            case .darkBackground_lightText: return ColorConstants.white45Percent
                
            case .lightBackground_darkText: return NSColor.black
                
            }
        }
        
        static var artistColor: NSColor {
            
            switch Colors.scheme {
                
            case .darkBackground_lightText: return ColorConstants.white60Percent
                
            case .lightBackground_darkText: return NSColor.black
                
            }
        }
    }
    
    // Color of text inside any of the container boxes
    static let boxTextColor: NSColor = ColorConstants.white70Percent
    
    static let fxFunctionTextColor: NSColor = ColorConstants.white40Percent
    
    static let fxFunctionPopupMenuTextColor: NSColor = ColorConstants.white60Percent
    
    static let filterChartTextColor: NSColor = ColorConstants.white85Percent
    
    static let editorHeaderTextColor: NSColor = ColorConstants.white85Percent
    
    // Color of text inside the playlist (non-selected items)
    static let playlistTextColor: NSColor = NSColor(calibratedWhite: 0.6, alpha: 1)
    // Color of selected item text inside the playlist
    static let playlistSelectedTextColor: NSColor = NSColor(calibratedWhite: 1, alpha: 1)
    
    // Color of text inside the playlist (non-selected items)
    static let playlistIndexTextColor: NSColor = NSColor(calibratedWhite: 0.3, alpha: 1)
    // Color of selected item text inside the playlist
    static let playlistSelectedIndexTextColor: NSColor = NSColor(calibratedWhite: 0.6, alpha: 1)
    
    static let playlistGroupIndexTextColor: NSColor = NSColor(calibratedWhite: 0.45, alpha: 1)
    // Color of selected item text inside the playlist
    static let playlistGroupSelectedIndexTextColor: NSColor = NSColor(calibratedWhite: 0.7, alpha: 1)
    
    static let overlayBackgroundColor: NSColor = NSColor(calibratedWhite: 0, alpha: 0.8)

    static let playlistGapTextColor: NSColor = NSColor(calibratedWhite: 0.8, alpha: 1)
    static let playlistSelectedGapTextColor: NSColor = NSColor(calibratedWhite: 1, alpha: 1)
    
    // Color for playlist grouped views
    static let playlistGroupNameTextColor: NSColor = NSColor(calibratedWhite: 0.5, alpha: 1)
    static let playlistGroupNameSelectedTextColor: NSColor = NSColor(calibratedWhite: 0.8, alpha: 1)
    
    static let playlistGroupItemTextColor: NSColor = NSColor(calibratedWhite: 0.6, alpha: 1)
    static let playlistGroupItemSelectedTextColor: NSColor = NSColor(calibratedWhite: 1, alpha: 1)
    
    // Fill color of box drawn around selected playlist item
    static let playlistSelectionBoxColor: NSColor = NSColor(calibratedWhite: 0.15, alpha: 1)
    
    static let editorSelectionBoxColor: NSColor = NSColor(calibratedWhite: 0.55, alpha: 1)
    
    // Fill color of all slider knobs
    static var neutralKnobColor: NSColor {
        
        switch scheme {
            
        case .darkBackground_lightText: return neutralKnobColor_darkBackground
            
        case .lightBackground_darkText: return neutralKnobColor_lightBackground
            
        }
    }
    
    static let neutralKnobColor_darkBackground: NSColor = NSColor(white: 0.5, alpha: 1.0)
    static let neutralKnobColor_lightBackground: NSColor = NSColor(white: 0, alpha: 1.0)
    
    static var seekBarPlainGradient: NSGradient {
        
        switch scheme {
            
        case .darkBackground_lightText: return seekBarPlainGradient_darkBackground
            
        case .lightBackground_darkText: return seekBarPlainGradient_lightBackground
            
        }
    }
    
    static let seekBarPlainGradient_darkBackground: NSGradient = {
        
        let backgroundStart = NSColor(white: 0.4, alpha: 1.0)
        let backgroundEnd =  NSColor(white: 0.2, alpha: 1.0)
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    static let seekBarPlainGradient_lightBackground: NSGradient = {
        
        let backgroundStart = NSColor(white: 0.3, alpha: 1.0)
        let backgroundEnd =  NSColor(white: 0.4, alpha: 1.0)
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    static var seekBarColoredGradient: NSGradient {
        
        switch scheme {
            
        case .darkBackground_lightText: return seekBarColoredGradient_darkBackground
            
        case .lightBackground_darkText: return seekBarColoredGradient_lightBackground
            
        }
    }
    
    static let seekBarColoredGradient_darkBackground: NSGradient = {
        
        let backgroundStart = NSColor(white: 0.6, alpha: 1.0)
        let backgroundEnd =  NSColor(white: 0.4, alpha: 1.0)
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    static let seekBarColoredGradient_lightBackground: NSGradient = {
        
        let backgroundStart = NSColor(white: 0, alpha: 1.0)
        let backgroundEnd =  NSColor(white: 0.2, alpha: 1.0)
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    static let activeKnobColor: NSColor = NSColor(red: 0, green: 0.625, blue: 0, alpha: 1)
    static let bypassedKnobColor: NSColor = NSColor(calibratedWhite: 0.6, alpha: 1)
    static let suppressedKnobColor: NSColor = NSColor(red: 0.8, green: 0.6, blue: 0, alpha: 1)
    
    // Outline color of buttons on modal dialogs
    static let modalDialogButtonOutlineColor: NSColor = NSColor(calibratedWhite: 0.575, alpha: 1)
    
    // Color used to fill tab view buttons
    static let tabViewButtonBackgroundColor: NSColor = NSColor.black
    
    static let transparentColor: NSColor = NSColor.white
    
    // Color used to outline tab view buttons
    static let tabViewButtonOutlineColor: NSColor = NSColor(calibratedWhite: 0.65, alpha: 1)
    
    // Color used for text in tab view buttons
    static let tabViewButtonTextColor: NSColor = ColorConstants.white90Percent
    
    // Color of the arrow drawn on popup menus
    static let popupMenuArrowColor: NSColor = NSColor(calibratedWhite: 0.1, alpha: 1)
    
    // A lighter version of popupMenuArrowColor
    static let lightPopupMenuArrowColor: NSColor = NSColor(calibratedWhite: 0.8, alpha: 1)
    
    // A lighter version of popupMenuArrowColor
    static let fxUnitPopupMenuArrowColor: NSColor = NSColor(calibratedWhite: 0.4, alpha: 1)
    
    // Color of the displayed text in popup menus
    static let popupMenuTextColor: NSColor = ColorConstants.white90Percent

    static let sliderBarGradient: NSGradient = {
        
        let backgroundStart = NSColor(white: 0.7, alpha: 1.0)
        let backgroundEnd =  NSColor(white: 0.2, alpha: 1.0)
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    static let popupMenuGradient: NSGradient = {
        
        let backgroundStart = NSColor(white: 0.35, alpha: 1.0)
        let backgroundEnd =  NSColor(white: 0.1, alpha: 1.0)
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    // Gradient used to fill slider bars
    static let sliderBarPlainGradient: NSGradient = {
        
        let backgroundStart = NSColor(white: 0.4, alpha: 1.0)
        let backgroundEnd =  NSColor(white: 0.1, alpha: 1.0)
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    static let scrollerKnobColor: NSColor = NSColor(white: 0.4, alpha: 1.0)
    static let scrollerBarColor: NSColor = NSColor(white: 0.25, alpha: 1.0)
    
    static let neutralSliderBarColoredGradient: NSGradient = {
        
        let backgroundStart = NSColor(white: 0.6, alpha: 1.0)
        let backgroundEnd =  NSColor(white: 0.4, alpha: 1.0)
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    static let activeSliderBarColoredGradient: NSGradient = {
        
        let backgroundStart = NSColor(red: 0, green: 0.625, blue: 0, alpha: 1)
        let backgroundEnd =  NSColor(red: 0, green: 0.2, blue: 0, alpha: 1)
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    static let bypassedSliderBarColoredGradient: NSGradient = {
        
        let backgroundStart = NSColor(calibratedWhite: 0.6, alpha: 1)
        let backgroundEnd =  NSColor(calibratedWhite: 0.3, alpha: 1)
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    static let suppressedSliderBarColoredGradient: NSGradient = {
        
        let backgroundStart = NSColor(red: 0.8, green: 0.6, blue: 0, alpha: 1)
        let backgroundEnd =  NSColor(red: 0.27, green: 0.2, blue: 0, alpha: 1)
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    static let bandStopGradient: NSGradient = {
        
        let backgroundStart = NSColor(red: 0.75, green: 0, blue: 0, alpha: 1)
        let backgroundEnd =  NSColor(red: 0.2, green: 0, blue: 0, alpha: 1)
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    static let playbackLoopGradient: NSGradient = {
        
        let backgroundStart = NSColor(red: 0, green: 0.6, blue: 0, alpha: 1)
        let backgroundEnd =  NSColor(red: 0, green: 0.3, blue: 0, alpha: 1)
        
//        let backgroundStart = NSColor(calibratedWhite: 1, alpha: 1)
//        let backgroundEnd =  NSColor(calibratedWhite: 0.6, alpha: 1)
        
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    
    
    static let progressBarColoredGradient: NSGradient = {
        
        let backgroundStart = NSColor(white: 0.7, alpha: 1.0)
        let backgroundEnd =  NSColor(white: 0.4, alpha: 1.0)
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    // Color of the ticks/notches on sliders
    static let sliderNotchColor: NSColor = NSColor(calibratedWhite: 0, alpha: 1)
    
    // Pop up menu (reverb/EQ/recorder) color
    static let popupMenuColor: NSColor = NSColor(calibratedWhite: 0.6, alpha: 1)
    
    // Fill color of box drawn around selected tab view item
    static let tabViewSelectionBoxColor: NSColor = NSColor(calibratedWhite: 0.125, alpha: 1)
    
    // Text color of modal dialog buttons
    static let modalDialogButtonTextColor: NSColor = NSColor(calibratedWhite: 0.9, alpha: 1)
    
    // Text color of modal dialog buttons
    static let fxUnitButtonTextColor: NSColor = NSColor(calibratedWhite: 0.6, alpha: 1)
    
    static let modalDialogButtonGradient: NSGradient = {
        
        let backgroundStart = NSColor(white: 0.5, alpha: 1.0)
        let backgroundEnd =  NSColor(white: 0.2, alpha: 1.0)
        return NSGradient(starting: backgroundStart, ending: backgroundEnd)!
    }()
    
    static let fxUnitButtonGradient: NSGradient = {
        
        let backgroundStart = NSColor(white: 0.35, alpha: 1.0)
        let backgroundEnd =  NSColor(white: 0.1, alpha: 1.0)
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    static let fxUnitButtonGradient_disabled: NSGradient = {
        
        let backgroundStart = NSColor(white: 0.175, alpha: 1.0)
        let backgroundEnd =  NSColor(white: 0.1, alpha: 1.0)
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    // Text color of modal dialog buttons
    static let modalDialogButtonTextColor_disabled: NSColor = NSColor(calibratedWhite: 0.5, alpha: 1)
    
    // Text color of modal dialog buttons
    static let fxUnitButtonTextColor_disabled: NSColor = NSColor(calibratedWhite: 0.45, alpha: 1)
    
    static let modalDialogButtonGradient_disabled: NSGradient = {
        
        let backgroundStart = NSColor(white: 0.25, alpha: 1.0)
        let backgroundEnd =  NSColor(white: 0.1, alpha: 1.0)
        return NSGradient(starting: backgroundStart, ending: backgroundEnd)!
    }()
    
    // Fill color of modal dialog navigation buttons (search)
    static let modalDialogNavButtonColor: NSColor = NSColor(calibratedWhite: 0.45, alpha: 1)
    
    // Fill color of text in modal dialog navigation buttons (search)
    static let modalDialogNavButtonTextColor: NSColor = NSColor(calibratedWhite: 0.9, alpha: 1)
    
    // Color of cursor inside text fields
    static let textFieldCursorColor: NSColor = NSColor(calibratedWhite: 0.5, alpha: 1)
    
    // Background color of the popover view
    static let popoverBackgroundColor: NSColor = NSColor(calibratedWhite: 0.1, alpha: 1)
}
