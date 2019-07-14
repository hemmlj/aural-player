import Cocoa

class MasterView: NSView {
    
    @IBOutlet weak var btnEQBypass: EffectsUnitTriStateBypassButton!
    @IBOutlet weak var btnPitchBypass: EffectsUnitTriStateBypassButton!
    @IBOutlet weak var btnTimeBypass: EffectsUnitTriStateBypassButton!
    @IBOutlet weak var btnReverbBypass: EffectsUnitTriStateBypassButton!
    @IBOutlet weak var btnDelayBypass: EffectsUnitTriStateBypassButton!
    @IBOutlet weak var btnFilterBypass: EffectsUnitTriStateBypassButton!
    
    @IBOutlet weak var imgEQBypass: EffectsUnitTriStateBypassImage!
    @IBOutlet weak var imgPitchBypass: EffectsUnitTriStateBypassImage!
    @IBOutlet weak var imgTimeBypass: EffectsUnitTriStateBypassImage!
    @IBOutlet weak var imgReverbBypass: EffectsUnitTriStateBypassImage!
    @IBOutlet weak var imgDelayBypass: EffectsUnitTriStateBypassImage!
    @IBOutlet weak var imgFilterBypass: EffectsUnitTriStateBypassImage!
    
    @IBOutlet weak var lblEQ: EffectsUnitTriStateLabel!
    @IBOutlet weak var lblPitch: EffectsUnitTriStateLabel!
    @IBOutlet weak var lblTime: EffectsUnitTriStateLabel!
    @IBOutlet weak var lblReverb: EffectsUnitTriStateLabel!
    @IBOutlet weak var lblDelay: EffectsUnitTriStateLabel!
    @IBOutlet weak var lblFilter: EffectsUnitTriStateLabel!
    
    private var buttons: [EffectsUnitTriStateBypassButton] = []
    private var images: [EffectsUnitTriStateBypassImage] = []
    private var labels: [EffectsUnitTriStateLabel] = []
    
    override func awakeFromNib() {
        buttons = [btnEQBypass, btnPitchBypass, btnTimeBypass, btnReverbBypass, btnDelayBypass, btnFilterBypass]
        images = [imgEQBypass, imgPitchBypass, imgTimeBypass, imgReverbBypass, imgDelayBypass, imgFilterBypass]
        labels = [lblEQ, lblPitch, lblTime, lblReverb, lblDelay, lblFilter]
    }
    
    func initialize(_ eqStateFunction: @escaping EffectsUnitStateFunction, _ pitchStateFunction: @escaping EffectsUnitStateFunction, _ timeStateFunction: @escaping EffectsUnitStateFunction, _ reverbStateFunction: @escaping EffectsUnitStateFunction, _ delayStateFunction: @escaping EffectsUnitStateFunction, _ filterStateFunction: @escaping EffectsUnitStateFunction) {
        
        btnEQBypass.stateFunction = eqStateFunction
        btnPitchBypass.stateFunction = pitchStateFunction
        btnTimeBypass.stateFunction = timeStateFunction
        btnReverbBypass.stateFunction = reverbStateFunction
        btnDelayBypass.stateFunction = delayStateFunction
        btnFilterBypass.stateFunction = filterStateFunction
        
        imgEQBypass.stateFunction = eqStateFunction
        imgPitchBypass.stateFunction = pitchStateFunction
        imgTimeBypass.stateFunction = timeStateFunction
        imgReverbBypass.stateFunction = reverbStateFunction
        imgDelayBypass.stateFunction = delayStateFunction
        imgFilterBypass.stateFunction = filterStateFunction
        
        lblEQ.stateFunction = eqStateFunction
        lblPitch.stateFunction = pitchStateFunction
        lblTime.stateFunction = timeStateFunction
        lblReverb.stateFunction = reverbStateFunction
        lblDelay.stateFunction = delayStateFunction
        lblFilter.stateFunction = filterStateFunction
        
        buttons.forEach({$0.updateState()})
        images.forEach({$0.updateState()})
        labels.forEach({$0.updateState()})
    }
    
    func stateChanged() {
        buttons.forEach({$0.updateState()})
        images.forEach({$0.updateState()})
        labels.forEach({$0.updateState()})
    }
    
    func applyPreset(_ preset: MasterPreset) {
        
        btnEQBypass.onIf(preset.eq.state == .active)
        btnPitchBypass.onIf(preset.pitch.state == .active)
        btnTimeBypass.onIf(preset.time.state == .active)
        btnReverbBypass.onIf(preset.reverb.state == .active)
        btnDelayBypass.onIf(preset.delay.state == .active)
        btnFilterBypass.onIf(preset.filter.state == .active)
        
        imgEQBypass.onIf(preset.eq.state == .active)
        imgPitchBypass.onIf(preset.pitch.state == .active)
        imgTimeBypass.onIf(preset.time.state == .active)
        imgReverbBypass.onIf(preset.reverb.state == .active)
        imgDelayBypass.onIf(preset.delay.state == .active)
        imgFilterBypass.onIf(preset.filter.state == .active)
        
        lblEQ.onIf(preset.eq.state == .active)
        lblPitch.onIf(preset.pitch.state == .active)
        lblTime.onIf(preset.time.state == .active)
        lblReverb.onIf(preset.reverb.state == .active)
        lblDelay.onIf(preset.delay.state == .active)
        lblFilter.onIf(preset.filter.state == .active)
    }
    
    func changeColorScheme() {
        [lblEQ, lblPitch, lblTime, lblReverb, lblDelay, lblFilter].forEach({$0?.colorSchemeChanged()})
    }
}
