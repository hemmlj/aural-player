import Cocoa

class FilterBandViewController: NSViewController {
    
    override var nibName: String? {return "FilterBand"}
    
    @IBOutlet weak var filterTypeMenu: NSPopUpButton!
    
    @IBOutlet weak var freqRangeSlider: FilterBandSlider!
    @IBOutlet weak var cutoffSlider: CutoffFrequencySlider!
    @IBOutlet weak var cutoffSliderCell: CutoffFrequencySliderCell!
    
    @IBOutlet weak var lblRangeCaption: NSTextField!
    @IBOutlet weak var lblPresetRangesCaption: NSTextField!
    @IBOutlet weak var presetRangesMenu: NSPopUpButton!
    
    @IBOutlet weak var lblCutoffCaption: NSTextField!
    @IBOutlet weak var lblPresetCutoffsCaption: NSTextField!
    @IBOutlet weak var presetCutoffsMenu: NSPopUpButton!
    
    @IBOutlet weak var lblFrequencies: NSTextField!
    
    private let filterUnit: FilterUnitDelegateProtocol = ObjectGraph.getAudioGraphDelegate().filterUnit
    
    private var modalDialogResponse: ModalDialogResponse = .ok
    private var editBandIndex: Int = -1
    
    var band: FilterBand = FilterBand.init(.bandStop).withMinFreq(AppConstants.audibleRangeMin).withMaxFreq(AppConstants.audibleRangeMax)
    var bandIndex: Int!
    
    override func awakeFromNib() {
        freqRangeSlider.onControlChanged = {(slider: RangeSlider) -> Void in self.freqRangeChanged()}
    }
    
    override func viewDidLoad() {
        resetFields()
    }
    
    private func resetFields() {
        
        bandTypeAction(self)
        presetCutoffsMenu.selectItem(at: -1)
        presetRangesMenu.selectItem(at: -1)
    }
    
    @IBAction func bandTypeAction(_ sender: Any) {
        
        let filterType = FilterBandType(rawValue: filterTypeMenu.titleOfSelectedItem!)!
        band.type = filterType
        
//        [freqRangeSlider, lblRangeCaption, lblPresetRangesCaption, presetRangesMenu].forEach({$0?.showIf_elseHide(filterType == .bandPass || filterType == .bandStop)})
//        [cutoffSlider, lblCutoffCaption, lblPresetCutoffsCaption, presetCutoffsMenu].forEach({$0?.hideIf_elseShow(filterType == .bandPass || filterType == .bandStop)})
        
        [freqRangeSlider, lblRangeCaption].forEach({$0?.showIf_elseHide(filterType == .bandPass || filterType == .bandStop)})
        [cutoffSlider, lblCutoffCaption].forEach({$0?.hideIf_elseShow(filterType == .bandPass || filterType == .bandStop)})
        
        if filterType == .bandPass || filterType == .bandStop {
            
            freqRangeSlider.filterType = filterType
            freqRangeChanged()
            
            band.minFreq = freqRangeSlider.startFrequency
            band.maxFreq = freqRangeSlider.endFrequency
            
        } else {
            
            cutoffSliderCell.filterType = filterType
            cutoffSlider.redraw()
            cutoffSliderAction(self)
            
            band.minFreq = filterType == .lowPass ? nil : cutoffSlider.frequency
            band.maxFreq = filterType == .lowPass ? cutoffSlider.frequency : nil
        }
        
        filterUnit.updateBand(bandIndex, band)
    }
    
    private func freqRangeChanged() {
        
        band.minFreq = freqRangeSlider.startFrequency
        band.maxFreq = freqRangeSlider.endFrequency
        
        filterUnit.updateBand(bandIndex, band)
        
        lblFrequencies.stringValue = String(format: "[%@ - %@]", formatFrequency(freqRangeSlider.startFrequency), formatFrequency(freqRangeSlider.endFrequency))
    }
    
    @IBAction func cutoffSliderAction(_ sender: Any) {
        
        band.minFreq = band.type == .lowPass ? nil : cutoffSlider.frequency
        band.maxFreq = band.type == .lowPass ? cutoffSlider.frequency : nil
        
        filterUnit.updateBand(bandIndex, band)
        
        lblFrequencies.stringValue = formatFrequency(cutoffSlider.frequency)
    }
    
    @IBAction func presetRangeAction(_ sender: NSPopUpButton) {
        
        if let range = sender.selectedItem as? FrequencyRangeMenuItem {
            
            freqRangeSlider.setStartFrequency(range.minFreq)
            freqRangeSlider.setEndFrequency(range.maxFreq)
            
            freqRangeChanged()
        }
        
        presetRangesMenu.selectItem(at: -1)
    }
    
    @IBAction func presetCutoffAction(_ sender: NSPopUpButton) {
        
        cutoffSlider.setFrequency(Float(sender.selectedItem!.tag))
        cutoffSliderAction(self)
        presetCutoffsMenu.selectItem(at: -1)
    }
    
    private func formatFrequency(_ freq: Float) -> String {
        
        let rounded = roundedInt(freq)
        
        if rounded % 1000 == 0 {
            return String(format: "%dKHz", rounded / 1000)
        } else {
            return String(format: "%dHz", rounded)
        }
    }
}
