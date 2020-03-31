/*
    Concrete implementation of RecorderDelegateProtocol
 */

import Foundation

class RecorderDelegate: RecorderDelegateProtocol {
    
    private var recorder: RecorderProtocol
    
    private let dispatchQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)
    
    init(_ recorder: RecorderProtocol) {
        self.recorder = recorder
    }
    
    func startRecording(_ params: RecordingParams) {
        recorder.startRecording(params)
    }
    
    func stopRecording() {
        
        // Perform asynchronously, to unblock the main thread
        dispatchQueue.async {
            self.recorder.stopRecording()
        }
    }
    
    func saveRecording(_ url: URL) {
        
        // Perform asynchronously, to unblock the main thread
        dispatchQueue.async {
            self.recorder.saveRecording(url)
        }
    }
    
    func deleteRecording() {
        
        // Perform asynchronously, to unblock the main thread
        dispatchQueue.async {
            self.recorder.deleteRecording()
        }
    }
    
    func getRecordingInfo() -> RecordingInfo? {
        return recorder.getRecordingInfo()
    }
    
    func isRecording() -> Bool{
        return recorder.isRecording()
    }
}
