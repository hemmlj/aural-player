import Cocoa

class GapView: NSView, ColorSchemeable, TextSizeable {
    
    @IBOutlet weak var lblTrackName: NSTextField!
    @IBOutlet weak var lblTimeRemaining: NSTextField!
    
    private var timer: RepeatingTaskExecutor?
    private var endTime: Date?
    
    func showView(_ playbackState: PlaybackState) {}
    
    func endGap() {
        
        timer?.stop()
        timer = nil
        endTime = nil
    }
    
    private func updateCountdown() {
        
        if let endTime = self.endTime {
        
            let seconds = max(DateUtils.timeUntil(endTime), 0)
            lblTimeRemaining.stringValue = StringUtils.formatSecondsToHMS(seconds)
            
            if seconds == 0 {endGap()}
        }
    }
    
    func gapStarted(_ msg: PlaybackGapStartedAsyncMessage) {
        
        let track = msg.nextTrack.track
        endTime = msg.gapEndTime
        
        lblTrackName.stringValue = String(format: "Up next:   %@", track.conciseDisplayName)
        updateCountdown()
        startTimer()
    }
    
    private func startTimer() {
        
        timer = RepeatingTaskExecutor(intervalMillis: 500, task: {self.updateCountdown()}, queue: DispatchQueue.main)
        timer?.startOrResume()
    }
    
    func handOff(_ other: GapView) {
        
        other.lblTrackName.stringValue = lblTrackName.stringValue
        other.lblTimeRemaining.stringValue = lblTimeRemaining.stringValue
        
        if endTime != nil {
            
            other.endTime = endTime
            other.updateCountdown()
            other.startTimer()
        }
    }
    
    func changeTextSize(_ size: TextSize) {
        
        lblTrackName.font = Fonts.Player.gapBoxTitleFont
        lblTimeRemaining.font = Fonts.Player.gapBoxTitleFont
    }
    
    func applyColorScheme(_ scheme: ColorScheme) {
        changeTextColor()
    }
    
    func changeTextColor() {
        
        lblTrackName.textColor = Colors.Player.gapTextColor
        lblTimeRemaining.textColor = Colors.Player.gapTextColor
    }
}