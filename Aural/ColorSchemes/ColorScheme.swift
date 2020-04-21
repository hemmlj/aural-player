import Cocoa

class ColorScheme {
    
    static var systemScheme: ColorScheme = ColorScheme()
    
    static func persistentState() -> ColorSchemesState {
        return ColorSchemesState(ColorSchemeState(systemScheme), [])
    }

    var logoTextColor: NSColor

    var backgroundColor: NSColor
    var controlButtonColor: NSColor
    var controlButtonOffStateColor: NSColor

    var primaryTextColor: NSColor
    var secondaryTextColor: NSColor
    
    var playerSliderForegroundColor: NSColor
    var playerSliderBackgroundColor: NSColor
    var playerSliderKnobColor: NSColor
    var playerSliderLoopSegmentColor: NSColor
    
    var playlistTrackNameTextColor: NSColor
    var playlistGroupNameTextColor: NSColor
    var playlistIndexDurationTextColor: NSColor
    
    var playlistTrackNameSelectedTextColor: NSColor
    var playlistGroupNameSelectedTextColor: NSColor
    var playlistIndexDurationSelectedTextColor: NSColor
    
    var playlistGroupIconColor: NSColor
    var playlistSelectionBoxColor: NSColor
    var playlistPlayingTrackIconColor: NSColor
    var playlistSummaryInfoColor: NSColor
    
    convenience init() {
        self.init(ColorSchemePreset.defaultScheme)
    }
    
    init(_ preset: ColorSchemePreset) {
        
        self.logoTextColor = preset.logoTextColor
        
        self.backgroundColor = preset.backgroundColor
        self.controlButtonColor = preset.controlButtonColor
        self.controlButtonOffStateColor = preset.controlButtonOffStateColor
        
        self.primaryTextColor = preset.primaryTextColor
        self.secondaryTextColor = preset.secondaryTextColor
        
        self.playerSliderBackgroundColor = preset.playerSliderBackgroundColor
        self.playerSliderForegroundColor = preset.playerSliderForegroundColor
        self.playerSliderKnobColor = preset.playerSliderKnobColor
        self.playerSliderLoopSegmentColor = preset.playerSliderLoopSegmentColor
        
        self.playlistTrackNameTextColor = preset.playlistTrackNameTextColor
        self.playlistGroupNameTextColor = preset.playlistGroupNameTextColor
        self.playlistIndexDurationTextColor = preset.playlistIndexDurationTextColor
        self.playlistTrackNameSelectedTextColor = preset.playlistTrackNameSelectedTextColor
        self.playlistGroupNameSelectedTextColor = preset.playlistGroupNameSelectedTextColor
        self.playlistIndexDurationSelectedTextColor = preset.playlistIndexDurationSelectedTextColor
        self.playlistGroupIconColor = preset.playlistGroupIconColor
        self.playlistSelectionBoxColor = preset.playlistSelectionBoxColor
        self.playlistPlayingTrackIconColor = preset.playlistPlayingTrackIconColor
        self.playlistSummaryInfoColor = preset.playlistSummaryInfoColor
        
    }
    
    func applyPreset(_ preset: ColorSchemePreset) {
        
        self.logoTextColor = preset.logoTextColor
        
        self.backgroundColor = preset.backgroundColor
        self.controlButtonColor = preset.controlButtonColor
        self.controlButtonOffStateColor = preset.controlButtonOffStateColor
        
        self.primaryTextColor = preset.primaryTextColor
        self.secondaryTextColor = preset.secondaryTextColor
        
        self.playerSliderBackgroundColor = preset.playerSliderBackgroundColor
        self.playerSliderForegroundColor = preset.playerSliderForegroundColor
        self.playerSliderKnobColor = preset.playerSliderKnobColor
        self.playerSliderLoopSegmentColor = preset.playerSliderLoopSegmentColor
        
        self.playlistTrackNameTextColor = preset.playlistTrackNameTextColor
        self.playlistGroupNameTextColor = preset.playlistGroupNameTextColor
        self.playlistIndexDurationTextColor = preset.playlistIndexDurationTextColor
        self.playlistTrackNameSelectedTextColor = preset.playlistTrackNameSelectedTextColor
        self.playlistGroupNameSelectedTextColor = preset.playlistGroupNameSelectedTextColor
        self.playlistIndexDurationSelectedTextColor = preset.playlistIndexDurationSelectedTextColor
        self.playlistGroupIconColor = preset.playlistGroupIconColor
        self.playlistSelectionBoxColor = preset.playlistSelectionBoxColor
        self.playlistPlayingTrackIconColor = preset.playlistPlayingTrackIconColor
        self.playlistSummaryInfoColor = preset.playlistSummaryInfoColor
    }
}

enum ColorSchemePreset: String {
    
    case darkBackgroundLightForeground
    
    case lightBackgroundDarkForeground
    
    static var defaultScheme: ColorSchemePreset {
        return darkBackgroundLightForeground
    }
    
    var logoTextColor: NSColor {
        
        switch self {
            
        case .darkBackgroundLightForeground:  return Colors.Constants.white80Percent
            
        case .lightBackgroundDarkForeground:  return NSColor.black
            
        }
    }
    
    var backgroundColor: NSColor {
        
        switch self {
            
        case .darkBackgroundLightForeground:  return NSColor.black
            
        case .lightBackgroundDarkForeground:  return Colors.Constants.white80Percent
            
        }
    }
    
    var controlButtonColor: NSColor {
        
        switch self {
            
        case .darkBackgroundLightForeground:  return Colors.Constants.white80Percent
            
        case .lightBackgroundDarkForeground:  return NSColor.black
            
        }
    }
    
    var controlButtonOffStateColor: NSColor {
        
        switch self {
            
        case .darkBackgroundLightForeground:  return Colors.Constants.white20Percent
            
        case .lightBackgroundDarkForeground:  return Colors.Constants.white60Percent
            
        }
    }
    
    var primaryTextColor: NSColor {
        
        switch self {
            
        case .darkBackgroundLightForeground:  return Colors.Constants.white80Percent
            
        case .lightBackgroundDarkForeground:  return NSColor.black
            
        }
    }
    
    var secondaryTextColor: NSColor {
        
        switch self {
            
        case .darkBackgroundLightForeground:  return Colors.Constants.white60Percent
            
        case .lightBackgroundDarkForeground:  return NSColor.darkGray
            
        }
    }
    
    var playerSliderForegroundColor: NSColor {
        
        switch self {
            
        case .darkBackgroundLightForeground:  return Colors.Constants.white60Percent
            
        case .lightBackgroundDarkForeground:  return NSColor.darkGray
            
        }
    }
    
    var playerSliderBackgroundColor: NSColor {
        
        switch self {
            
        case .darkBackgroundLightForeground:  return Colors.Constants.white20Percent
            
        case .lightBackgroundDarkForeground:  return Colors.Constants.white50Percent
            
        }
    }
    
    var playerSliderKnobColor: NSColor {
        
        switch self {
            
        case .darkBackgroundLightForeground:  return Colors.Constants.white50Percent
            
        case .lightBackgroundDarkForeground:  return NSColor.darkGray
            
        }
    }
    
    var playerSliderLoopSegmentColor: NSColor {
        
        switch self {
            
        case .darkBackgroundLightForeground:  return NSColor(red: 0, green: 0.625, blue: 0, alpha: 1)
            
        case .lightBackgroundDarkForeground:  return NSColor(red: 0, green: 0.625, blue: 0, alpha: 1)
            
        }
    }
    
    // MARK: Playlist colors ------------------------------------------------------------------------------------------------------
    
    var playlistTrackNameTextColor: NSColor {
        
        switch self {
            
        case .darkBackgroundLightForeground:  return Colors.Constants.white70Percent
            
        case .lightBackgroundDarkForeground:  return Colors.Constants.white20Percent
            
        }
    }
    
    var playlistGroupNameTextColor: NSColor {
        
        switch self {
            
        case .darkBackgroundLightForeground:  return Colors.Constants.white60Percent
            
        case .lightBackgroundDarkForeground:  return Colors.Constants.white30Percent
            
        }
    }
    
    var playlistIndexDurationTextColor: NSColor {
        
        switch self {
            
        case .darkBackgroundLightForeground:  return Colors.Constants.white40Percent
            
        case .lightBackgroundDarkForeground:  return Colors.Constants.white60Percent
            
        }
    }
    
    var playlistTrackNameSelectedTextColor: NSColor {
        
        switch self {
            
        case .darkBackgroundLightForeground:  return NSColor.white
            
        case .lightBackgroundDarkForeground:  return Colors.Constants.white10Percent
            
        }
    }
    
    var playlistGroupNameSelectedTextColor: NSColor {
        
        switch self {
            
        case .darkBackgroundLightForeground:  return Colors.Constants.white80Percent
            
        case .lightBackgroundDarkForeground:  return Colors.Constants.white20Percent
            
        }
    }
    
    var playlistIndexDurationSelectedTextColor: NSColor {
        
        switch self {
            
        case .darkBackgroundLightForeground:  return Colors.Constants.white60Percent
            
        case .lightBackgroundDarkForeground:  return Colors.Constants.white20Percent
            
        }
    }
    
    var playlistGroupIconColor: NSColor {
        
        switch self {
            
        case .darkBackgroundLightForeground:  return Colors.Constants.white50Percent
            
        case .lightBackgroundDarkForeground:  return Colors.Constants.white50Percent
            
        }
    }
    
    var playlistSelectionBoxColor: NSColor {
        
        switch self {
            
        case .darkBackgroundLightForeground:  return Colors.Constants.white15Percent
            
        case .lightBackgroundDarkForeground:  return Colors.Constants.white70Percent
            
        }
    }
    
    var playlistPlayingTrackIconColor: NSColor {
        
        switch self {
            
        case .darkBackgroundLightForeground:  return NSColor(red: 0, green: 0.8, blue: 0, alpha: 1)
            
        case .lightBackgroundDarkForeground:  return NSColor(red: 0, green: 0.425, blue: 0, alpha: 1)
            
        }
    }
    
    var playlistSummaryInfoColor: NSColor {
        
        switch self {
            
        case .darkBackgroundLightForeground:  return Colors.Constants.white70Percent
            
        case .lightBackgroundDarkForeground:  return Colors.Constants.white30Percent
            
        }
    }
}
