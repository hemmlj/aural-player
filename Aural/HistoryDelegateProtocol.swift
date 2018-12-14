import Foundation

/*
    Contract for a delegate that performs CRUD on the History model
 */
protocol HistoryDelegateProtocol {
    
    // Retrieves all items from the Recently added list, in chronological order
    func allRecentlyAddedItems() -> [AddedItem]
    
    // Retrieves all recently played items
    func allRecentlyPlayedItems() -> [PlayedItem]
    
    // Adds a given item (file/folder) to the playlist
    func addItem(_ item: URL)
    
    // Plays a given item track. The "playlistType" parameter is used to initialize the new playback sequence, based on the current playlist view.
    func playItem(_ item: URL, _ playlistType: PlaylistType)
    
    func resizeLists(_ recentlyAddedListSize: Int, _ recentlyPlayedListSize: Int)
    
    func clearAllHistory()
    
    var lastPlayedTrack: Track? {get}
}
