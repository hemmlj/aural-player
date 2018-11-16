import AVFoundation

/* 
    Container for parameters for a single recording session.
 */
class RecordingSession {
    
    // The temporary file that will hold the recording, till the user specifies a path
    let tempFilePath: String
    
    // Audio format of the recording
    let format: RecordingFormat
    
    // Used to determine the current recording duration
    var startTime: Date?
    
    // Whether or not the recording is ongoing
    var active: Bool
    
    // The current recording session, if any
    private static var currentSession: RecordingSession?
    
    // Used to append timestamps to temp recording files
    private static var dateFormatter = { () -> DateFormatter in
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy_hh-mm-ss"
        
        return formatter
    }()
    
    init(_ format: RecordingFormat, _ tempFilePath: String) {
        
        self.tempFilePath = tempFilePath
        self.format = format
        self.active = true
    }
    
    // Returns recording metadata for UI display
    func getRecordingInfo() -> RecordingInfo {
        
        // Duration = now - startTime
        let now = Date()
        let duration = now.timeIntervalSince(startTime!)
        let size = FileSystemUtils.sizeOfFile(path: tempFilePath)
        
        return RecordingInfo(format, duration, size)
    }
    
    // Initiates a new recording session and returns it
    static func start(_ format: RecordingFormat) -> RecordingSession {
        
        let nowString = dateFormatter.string(from: Date())
        
        let tempFilePath = String(format: "%@/aural-tempRecording_%@.%@", AppConstants.FilesAndPaths.recordingDir.path, nowString, format.fileExtension)
        
        currentSession = RecordingSession(format, tempFilePath)
        return currentSession!
    }
    
    // Checks if any recording is ongoing
    static func hasCurrentSession() -> Bool {
        return currentSession != nil
    }
    
    // Returns the current recording session, if any
    static func getCurrentSession() -> RecordingSession? {
        return currentSession
    }
    
    // Ends the current session, if there is one. Once a session is ended, it can still be obtained using getCurrentSession().
    static func endCurrentSession() {
        currentSession?.active = false
    }
    
    // Invalidates the current session, if there is one. Once a session is invalidated, no references to it can be obtained using getCurrentSession().
    static func invalidateCurrentSession() {
        currentSession = nil
    }
}
