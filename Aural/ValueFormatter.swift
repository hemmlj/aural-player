/*
    Utilities for formatting numerical values into user-friendly displayable representations with units (e.g. "20 Hz" for frequency values)
 */

import Foundation

class ValueFormatter {
    
    private static var numberFormatter = { () -> NumberFormatter in
        
       let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.minimumIntegerDigits = 1
        
        return formatter
    }()
    
    static func formatVolume(_ value: Float) -> String {
        return String(format: "%d%%", Int(round(value)))
    }
    
    static func formatPan(_ value: Float) -> String {
        
        let panVal = Int(round(value))
        
        if (panVal < 0) {
            return String(format: "L (%d%%)", abs(panVal))
        } else if (panVal > 0) {
            return String(format: "R (%d%%)", panVal)
        } else {
            return "C"
        }
    }
    
    static func formatPitch(_ value: Float) -> String {
        return formatValueWithUnits(NSNumber(value: value), 1, AppConstants.Units.pitchOctaves, true)
    }
    
    static func formatOverlap(_ value: Float) -> String {
        return ValueFormatter.formatValue(NSNumber(value: value), 1)
    }
    
    static func formatTimeStretchRate(_ value: Float) -> String {
        return ValueFormatter.formatValueWithUnits(NSNumber(value: value), 2, AppConstants.Units.timeStretchRate, false)
    }
    
    static func formatReverbAmount(_ value: Float) -> String {
        
        if (value == 0) {
            return String(format: "100%% %@", AppConstants.Units.reverbDryAmount)
        } else if (value == 100) {
            return String(format: "100%% %@", AppConstants.Units.reverbWetAmount)
        } else {
            let dry = Int(round(value))
            let wet = 100 - dry
            return String(format:"%d / %d", dry, wet)
        }
    }
    
    static func formatDelayTime(_ value: Double) -> String {
        return ValueFormatter.formatValueWithUnits(NSNumber(value: value), 2, AppConstants.Units.delayTimeSecs, false)
    }
    
    static func formatDelayAmount(_ value: Float) -> String {
        return ValueFormatter.formatValue(NSNumber(value: value), 0)
    }
    
    static func formatDelayFeedback(_ value: Float) -> String {
        return ValueFormatter.formatValueWithUnits(NSNumber(value: value), 0, AppConstants.Units.delayFeedbackPerc, false)
    }
    
    static func formatDelayLowPassCutoff(_ value: Float) -> String {
        return formatFrequency(value)
    }
    
    static func formatFilterFrequencyRange(_ value1: Double, _ value2: Double) -> String {
        return String(format: "[ %d %@ - %d %@ ]", Int(value1), AppConstants.Units.frequencyHz, Int(value2), AppConstants.Units.frequencyHz)
    }
    
    static func formatFilterFrequencyRange(_ value1: Float, _ value2: Float) -> String {
        return String(format: "[ %d %@ - %d %@ ]", Int(value1), AppConstants.Units.frequencyHz, Int(value2), AppConstants.Units.frequencyHz)
    }
    
    static func formatFrequency(_ value: Float) -> String {
        return String(format: "%d %@", Int(value), AppConstants.Units.frequencyHz)
    }
    
    static func formatValueWithUnits(_ value: NSNumber, _ decimalDigits: Int, _ unit: String, _ includeSpace: Bool) -> String {
        
        numberFormatter.maximumFractionDigits = decimalDigits
        
        var numStr = numberFormatter.string(from: value)!
        
        if (numStr == "-0") {
            numStr = "0"
        }
        
        return includeSpace ? String(format: "%@ %@", numStr, unit) : String(format: "%@%@", numStr, unit)
    }
    
    static func formatValue(_ value: NSNumber, _ decimalDigits: Int) -> String {
        
        numberFormatter.locale = Locale(identifier: "en_US_POSIX")
        numberFormatter.maximumFractionDigits = decimalDigits
        numberFormatter.minimumIntegerDigits = 1
        
        return numberFormatter.string(from: value)!
    }
    
    static func formatPixels(_ value: Float) -> String {
        
        return formatValueWithUnits(NSNumber(value: value), 0, AppConstants.Units.screenRealEstatePixel, false)
    }
}
