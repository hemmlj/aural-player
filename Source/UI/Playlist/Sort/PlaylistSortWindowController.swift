import Cocoa

/*
    Window controller for the playlist sort dialog
 */
class PlaylistSortWindowController: NSWindowController, ModalDialogDelegate {
    
    @IBOutlet weak var container: NSBox!
    
    private var tracksPlaylistSortView: SortViewProtocol = TracksPlaylistSortViewController()
    private var artistsPlaylistSortView: SortViewProtocol = ArtistsPlaylistSortViewController()
    private var albumsPlaylistSortView: SortViewProtocol = AlbumsPlaylistSortViewController()
    private var genresPlaylistSortView: SortViewProtocol = GenresPlaylistSortViewController()
    
    // Delegate that relays sort requests to the playlist
    private let playlist: PlaylistDelegateProtocol = ObjectGraph.playlistDelegate
    
    private var modalDialogResponse: ModalDialogResponse = .ok
    
    override var windowNibName: String? {return "PlaylistSortDialog"}
    
    private var theWindow: NSWindow {self.window!}
    
    private var displayedSortView: SortViewProtocol!
    
    override func windowDidLoad() {
        
        container.addSubviews(tracksPlaylistSortView.sortView, artistsPlaylistSortView.sortView, albumsPlaylistSortView.sortView, genresPlaylistSortView.sortView)
        
        [tracksPlaylistSortView, artistsPlaylistSortView, albumsPlaylistSortView, genresPlaylistSortView].forEach {$0.resetFields()}
        
        WindowManager.registerModalComponent(self)
    }
    
    var isModal: Bool {window?.isVisible ?? false}
    
    func showDialog() -> ModalDialogResponse {
        
        // Don't do anything if either no tracks or only 1 track in playlist
        guard playlist.size >= 2 else {return .cancel}
        
        // Force loading of the window if it hasn't been loaded yet (only once)
        if !self.isWindowLoaded {_ = theWindow}
        
        // Choose sort view based on current playlist view
        NSView.hideViews(tracksPlaylistSortView.sortView, artistsPlaylistSortView.sortView, albumsPlaylistSortView.sortView, genresPlaylistSortView.sortView)
        
        switch PlaylistViewState.current {

        case .tracks:       displayedSortView = tracksPlaylistSortView
            
        case .artists:      displayedSortView = artistsPlaylistSortView
            
        case .albums:       displayedSortView = albumsPlaylistSortView
            
        case .genres:       displayedSortView = genresPlaylistSortView

        }
        
        displayedSortView.sortView.show()
        
        UIUtils.showDialog(theWindow)
        return modalDialogResponse
    }
    
    @IBAction func sortBtnAction(_ sender: Any) {

        // Perform the sort
        playlist.sort(displayedSortView.sortOptions, displayedSortView.playlistType)
        
        // Notify playlist views
        Messenger.publish(.playlist_refresh, payload: PlaylistViewSelector.forView(displayedSortView.playlistType))
        
        modalDialogResponse = .ok
        UIUtils.dismissDialog(theWindow)
    }
    
    @IBAction func sortCancelBtnAction(_ sender: Any) {
        
        modalDialogResponse = .cancel
        UIUtils.dismissDialog(theWindow)
    }
}

// Contract for a constituent view of the playlist sort dialog.
protocol SortViewProtocol {
    
    // The actual displayed view
    var sortView: NSView {get}
    
    // The set of sort options selected within this view
    var sortOptions: Sort {get}
    
    // The playlist type associated with this view.
    var playlistType: PlaylistType {get}
    
    // Resets fields each time this view is about to be displayed.
    func resetFields()
}
