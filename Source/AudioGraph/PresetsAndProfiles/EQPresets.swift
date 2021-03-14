import Foundation

class EQPresets: FXPresets<EQPreset> {
    
    override init() {
     
        super.init()
        addPresets(SystemDefinedEQPresets.presets)
    }
    
    static var defaultPreset: EQPreset = {return SystemDefinedEQPresets.presets.first(where: {$0.name == SystemDefinedEQPresetParams.flat.rawValue})!}()
}

class EQPreset: EffectsUnitPreset {
    
    let bands: [Float]
    let globalGain: Float
    
    init(_ name: String, _ state: EffectsUnitState, _ bands: [Float], _ globalGain: Float, _ systemDefined: Bool) {
        
        self.bands = bands
        self.globalGain = globalGain
        super.init(name, state, systemDefined)
    }
}

fileprivate struct SystemDefinedEQPresets {
    
    static let presets: [EQPreset] = SystemDefinedEQPresetParams.allCases.map { EQPreset($0.rawValue, $0.state, $0.bands, $0.globalGain, true) }
}

/*
    An enumeration of Equalizer presets the user can choose from
 */
fileprivate enum SystemDefinedEQPresetParams: String, CaseIterable {
    
    case flat = "Flat" // default
    case highBassAndTreble = "High bass and treble"
    
    case dance = "Dance"
    case electronic = "Electronic"
    case hipHop = "Hip Hop"
    case jazz = "Jazz"
    case latin = "Latin"
    case lounge = "Lounge"
    case piano = "Piano"
    case pop = "Pop"
    case rAndB = "R&B"
    case rock = "Rock"
    
    case soft = "Soft"
    case karaoke = "Karaoke"
    case vocal = "Vocal"
    
    // Converts a user-friendly display name to an instance of EQPresets
    static func fromDisplayName(_ displayName: String) -> SystemDefinedEQPresetParams {
        return SystemDefinedEQPresetParams(rawValue: displayName) ?? .flat
    }
    
    // Returns the frequency->gain mappings for each of the frequency bands, for this preset
    var bands: [Float] {
        
        switch self {
            
        case .flat: return EQPresetsBands.flatBands
        case .highBassAndTreble: return EQPresetsBands.highBassAndTrebleBands
            
        case .dance: return EQPresetsBands.danceBands
        case .electronic: return EQPresetsBands.electronicBands
        case .hipHop: return EQPresetsBands.hipHopBands
        case .jazz: return EQPresetsBands.jazzBands
        case .latin: return EQPresetsBands.latinBands
        case .lounge: return EQPresetsBands.loungeBands
        case .piano: return EQPresetsBands.pianoBands
        case .pop: return EQPresetsBands.popBands
        case .rAndB: return EQPresetsBands.rAndBBands
        case .rock: return EQPresetsBands.rockBands
            
        case .soft: return EQPresetsBands.softBands
        case .vocal: return EQPresetsBands.vocalBands
        case .karaoke: return EQPresetsBands.karaokeBands
            
        }
    }
    
    var globalGain: Float {
        return 0
    }
    
    var state: EffectsUnitState {
        return .active
    }
}

// Container for specific frequency->gain mappings for different EQ presets
fileprivate struct EQPresetsBands {
    
    static let flatBands: [Float] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    static let highBassAndTrebleBands: [Float] = [15, 12.5, 10, 0, 0, 0, 0, 10, 12.5, 15]
    
    static let danceBands: [Float] = [0, 7, 4, 0, -1, -2, -4, 0, 4, 5]
    
    static let electronicBands: [Float] = [7, 6.5, 0, -2, -5, 0, 0, 0, 6.5, 7]
    
    static let hipHopBands: [Float] = [7, 7, 0, 0, -3, -3, -2, 1, 1, 7]
    
    static let jazzBands: [Float] = [0, 3, 0, 0, -3, -3, 0, 0, 3, 5]
    
    static let latinBands: [Float] = [8, 5, 0, 0, -4, -4, -4, 0, 6, 8]
    
    static let loungeBands: [Float] = [-5, -2, 0, 2, 4, 3, 0, 0, 3, 0]
    
    static let pianoBands: [Float] = [1, -1, -3, 0, 1, -1, 2, 3, 1, 2]
    
    static let popBands: [Float] = [-2, -1.5, 0, 3, 7, 7, 3.5, 0, -2, -3]
    
    static let rAndBBands: [Float] = [0, 7, 4, -3, -5, -4.5, -2, -1.5, 0, 1.5]
    
    static let rockBands: [Float] = [5, 3, 1.5, 0, -5, -6, -2.5, 0, 2.5, 4]
    
    static let softBands: [Float] = [0, 1, 2, 6, 8, 10, 12, 12, 13, 14]
    
    static let karaokeBands: [Float] = [8, 6, 4, -20, -20, -20, -20, 4, 6, 8]
    
    static let vocalBands: [Float] = [-20, -20, -20, 12, 14, 14, 12, -20, -20, -20]
}
