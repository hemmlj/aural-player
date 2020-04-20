/*
    Container for colors used by the UI
*/

import Cocoa

struct Colors {
    
    struct Constants {
        
        static let white10Percent: NSColor = NSColor(calibratedWhite: 0.1, alpha: 1)
        static let white13_5Percent: NSColor = NSColor(calibratedWhite: 0.135, alpha: 1)
        static let white15Percent: NSColor = NSColor(calibratedWhite: 0.15, alpha: 1)
        static let white20Percent: NSColor = NSColor(calibratedWhite: 0.2, alpha: 1)
        static let white25Percent: NSColor = NSColor(calibratedWhite: 0.25, alpha: 1)
        static let white30Percent: NSColor = NSColor(calibratedWhite: 0.3, alpha: 1)
        static let white35Percent: NSColor = NSColor(calibratedWhite: 0.35, alpha: 1)
        static let white40Percent: NSColor = NSColor(calibratedWhite: 0.4, alpha: 1)
        static let white45Percent: NSColor = NSColor(calibratedWhite: 0.45, alpha: 1)
        static let white50Percent: NSColor = NSColor(calibratedWhite: 0.5, alpha: 1)
        static let white60Percent: NSColor = NSColor(calibratedWhite: 0.6, alpha: 1)
        static let white70Percent: NSColor = NSColor(calibratedWhite: 0.7, alpha: 1)
        static let white80Percent: NSColor = NSColor(calibratedWhite: 0.8, alpha: 1)
        static let white85Percent: NSColor = NSColor(calibratedWhite: 0.85, alpha: 1)
        static let white90Percent: NSColor = NSColor(calibratedWhite: 0.9, alpha: 1)
    }
    
    struct Player {
        
        static var trackInfoTitleTextColor: NSColor {
            return ColorScheme.systemScheme.primaryTextColor
        }
        
        static var trackInfoArtistAlbumTextColor: NSColor {
            return ColorScheme.systemScheme.secondaryTextColor
        }
        
        static var trackInfoChapterTextColor: NSColor {
            return ColorScheme.systemScheme.secondaryTextColor
        }
        
        static var gapTextColor: NSColor {
            return ColorScheme.systemScheme.primaryTextColor
        }
        
        static var trackTimesTextColor: NSColor {
            return ColorScheme.systemScheme.secondaryTextColor
        }
        
        static var feedbackTextColor: NSColor {
            return ColorScheme.systemScheme.secondaryTextColor
        }
        
        static var seekBarBackgroundGradient: NSGradient {
            
            return NSGradient(starting: ColorScheme.systemScheme.playerSliderBackgroundColor,
                              ending: ColorScheme.systemScheme.playerSliderBackgroundColor)!
        }
        
        static var seekBarProgressGradient: NSGradient {
            
            return NSGradient(starting: ColorScheme.systemScheme.playerSliderForegroundColor,
                              ending: ColorScheme.systemScheme.playerSliderForegroundColor)!
        }
        
        static var seekBarLoopGradient: NSGradient {
            
            return NSGradient(starting: ColorScheme.systemScheme.playerSliderLoopSegmentColor,
                              ending: ColorScheme.systemScheme.playerSliderLoopSegmentColor)!
        }
        
        static var knobColor: NSColor {
            return ColorScheme.systemScheme.playerSliderKnobColor
        }
    }
    
    struct Playlist {
        
        static var trackNameTextColor: NSColor {
            return ColorScheme.systemScheme.playlistTrackNameTextColor
        }
        
        static var groupNameTextColor: NSColor {
            return ColorScheme.systemScheme.playlistGroupNameTextColor
        }
        
        static var indexDurationTextColor: NSColor {
            return ColorScheme.systemScheme.playlistIndexDurationTextColor
        }
        
        static var trackNameSelectedTextColor: NSColor {
            return ColorScheme.systemScheme.playlistTrackNameSelectedTextColor
        }
        
        static var groupNameSelectedTextColor: NSColor {
            return ColorScheme.systemScheme.playlistGroupNameSelectedTextColor
        }
        
        static var indexDurationSelectedTextColor: NSColor {
            return ColorScheme.systemScheme.playlistIndexDurationSelectedTextColor
        }
    }
    
    static let fxFunctionTextColor: NSColor = Constants.white40Percent
    
    static let fxFunctionPopupMenuTextColor: NSColor = Constants.white60Percent
    
    static let filterChartTextColor: NSColor = Constants.white85Percent
    
    static let editorHeaderTextColor: NSColor = Constants.white85Percent
    
    // Color of text inside the playlist (non-selected items)
    static let playlistTextColor: NSColor = Constants.white60Percent
    
    // Color of selected item text inside the playlist
    static let playlistSelectedTextColor: NSColor = NSColor.white
    
    // Color of text inside the playlist (non-selected items)
    static let playlistIndexTextColor: NSColor = Constants.white30Percent
    
    // Color of selected item text inside the playlist
    static let playlistSelectedIndexTextColor: NSColor = Constants.white60Percent
    
    static let playlistGroupIndexTextColor: NSColor = Constants.white45Percent
    
    // Color of selected item text inside the playlist
    static let playlistGroupSelectedIndexTextColor: NSColor = Constants.white70Percent
    
    static let playlistGapTextColor: NSColor = Constants.white80Percent
    static let playlistSelectedGapTextColor: NSColor = NSColor.white
    
    // Color for playlist grouped views
    static let playlistGroupNameTextColor: NSColor = Constants.white50Percent
    static let playlistGroupNameSelectedTextColor: NSColor = Constants.white80Percent
    
    static let playlistGroupItemTextColor: NSColor = Constants.white60Percent
    static let playlistGroupItemSelectedTextColor: NSColor = NSColor.white
    
    // Fill color of box drawn around selected playlist item
    static let playlistSelectionBoxColor: NSColor = Constants.white15Percent
    
    static let editorSelectionBoxColor: NSColor = NSColor(calibratedWhite: 0.55, alpha: 1)
    
    // Fill color of all slider knobs
    static let activeKnobColor: NSColor = NSColor(red: 0, green: 0.625, blue: 0, alpha: 1)
    static let bypassedKnobColor: NSColor = Constants.white60Percent
    static let suppressedKnobColor: NSColor = NSColor(red: 0.8, green: 0.6, blue: 0, alpha: 1)
    
    // Outline color of buttons on modal dialogs
    static let modalDialogButtonOutlineColor: NSColor = NSColor(calibratedWhite: 0.575, alpha: 1)
    
    // Color used to fill tab view buttons
    static let tabViewButtonBackgroundColor: NSColor = NSColor.black
    static let tabViewButtonSelectionBoxColor: NSColor = Constants.white13_5Percent
    
    static let transparentColor: NSColor = NSColor.white
    
    // Color used to outline tab view buttons
    static let tabViewButtonOutlineColor: NSColor = NSColor(calibratedWhite: 0.65, alpha: 1)
    
    // Color used for text in tab view buttons
    static let tabViewButtonTextColor: NSColor = Constants.white90Percent
    
    // Color of the arrow drawn on popup menus
    static let popupMenuArrowColor: NSColor = Constants.white10Percent
    
    // A lighter version of popupMenuArrowColor
    static let lightPopupMenuArrowColor: NSColor = Constants.white80Percent
    
    // A lighter version of popupMenuArrowColor
    static let fxUnitPopupMenuArrowColor: NSColor = Constants.white40Percent
    
    // Color of the displayed text in popup menus
    static let popupMenuTextColor: NSColor = Constants.white90Percent

    static let sliderBarGradient: NSGradient = {
        
        let backgroundStart = Constants.white70Percent
        let backgroundEnd =  Constants.white20Percent
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    static let popupMenuGradient: NSGradient = {
        
        let backgroundStart = Constants.white35Percent
        let backgroundEnd =  Constants.white10Percent
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    // Gradient used to fill slider bars
    static let sliderBarPlainGradient: NSGradient = {
        
        let backgroundStart = Constants.white40Percent
        let backgroundEnd =  Constants.white10Percent
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    static let scrollerKnobColor: NSColor = Constants.white40Percent
    static let scrollerBarColor: NSColor = Constants.white25Percent
    
    static let neutralSliderBarColoredGradient: NSGradient = {
        
        let backgroundStart = Constants.white60Percent
        let backgroundEnd =  Constants.white40Percent
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
        
        let backgroundStart = Constants.white60Percent
        let backgroundEnd =  Constants.white30Percent
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
        
        let backgroundStart = NSColor(red: 1, green: 0, blue: 0, alpha: 1)
        let backgroundEnd =  NSColor(red: 0.5, green: 0, blue: 0, alpha: 1)
        
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    static let progressBarColoredGradient: NSGradient = {
        
        let backgroundStart = Constants.white70Percent
        let backgroundEnd =  Constants.white40Percent
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    static let seekBarColoredGradient: NSGradient = Colors.neutralSliderBarColoredGradient
    
    // Color of the ticks/notches on sliders
    static let sliderNotchColor: NSColor = NSColor.black
    
    // Pop up menu (reverb/EQ/recorder) color
    static let popupMenuColor: NSColor = Constants.white60Percent
    
    // Fill color of box drawn around selected tab view item
    static let tabViewSelectionBoxColor: NSColor = NSColor(calibratedWhite: 0.125, alpha: 1)
    
    // Text color of modal dialog buttons
    static let modalDialogButtonTextColor: NSColor = Constants.white90Percent
    
    // Text color of modal dialog buttons
    static let fxUnitButtonTextColor: NSColor = Constants.white60Percent
    
    static let modalDialogButtonGradient: NSGradient = {
        
        let backgroundStart = Constants.white50Percent
        let backgroundEnd =  Constants.white20Percent
        return NSGradient(starting: backgroundStart, ending: backgroundEnd)!
    }()
    
    static let fxUnitButtonGradient: NSGradient = {
        
        let backgroundStart = Constants.white35Percent
        let backgroundEnd =  Constants.white10Percent
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    static let fxUnitButtonGradient_disabled: NSGradient = {
        
        let backgroundStart = NSColor(calibratedWhite: 0.175, alpha: 1)
        let backgroundEnd =  Constants.white10Percent
        let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
        
        return barBackgroundGradient!
    }()
    
    // Text color of modal dialog buttons
    static let modalDialogButtonTextColor_disabled: NSColor = Constants.white50Percent
    
    // Text color of modal dialog buttons
    static let fxUnitButtonTextColor_disabled: NSColor = Constants.white45Percent
    
    static let modalDialogButtonGradient_disabled: NSGradient = {
        
        let backgroundStart = Constants.white25Percent
        let backgroundEnd =  Constants.white10Percent
        return NSGradient(starting: backgroundStart, ending: backgroundEnd)!
    }()
    
    // Fill color of modal dialog navigation buttons (search)
    static let modalDialogNavButtonColor: NSColor = Constants.white45Percent
    
    // Fill color of text in modal dialog navigation buttons (search)
    static let modalDialogNavButtonTextColor: NSColor = Constants.white90Percent
    
    // Color of cursor inside text fields
    static let textFieldCursorColor: NSColor = Constants.white50Percent
    
    // Background color of the popover view
    static let popoverBackgroundColor: NSColor = Constants.white15Percent
    
    // Color of text inside any of the container boxes
    static let boxTextColor: NSColor = Constants.white70Percent
}
