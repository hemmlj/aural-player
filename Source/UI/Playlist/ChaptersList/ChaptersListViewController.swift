import Cocoa

/*
 View controller for the Chapters list.
 Displays the chapters list in a tabular format, and provides chapter search and playback functions.
 */
class ChaptersListViewController: NSViewController, ModalComponentProtocol, MessageSubscriber, ActionMessageSubscriber {
    
    @IBOutlet weak var chaptersListView: NSTableView!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var clipView: NSClipView!
    
    @IBOutlet weak var header: NSTableHeaderView!
    
    @IBOutlet weak var lblWindowTitle: NSTextField!
    @IBOutlet weak var lblSummary: NSTextField!
    
    @IBOutlet weak var btnClose: TintedImageButton!
    @IBOutlet weak var btnPreviousChapter: TintedImageButton!
    @IBOutlet weak var btnNextChapter: TintedImageButton!
    @IBOutlet weak var btnReplayChapter: TintedImageButton!
    @IBOutlet weak var btnLoopChapter: OnOffImageButton!
    
    @IBOutlet weak var txtSearch: NSSearchField!
    @IBOutlet weak var btnCaseSensitive: OnOffImageButton!
    
    @IBOutlet weak var lblNumMatches: NSTextField!
    @IBOutlet weak var btnPreviousMatch: TintedImageButton!
    @IBOutlet weak var btnNextMatch: TintedImageButton!
    
    private var functionButtons: [Tintable] = []
    
    // Holds all search results from the latest performed search
    private var searchResults: [Int] = []
    
    // Points to the current search result selected within the chapters list, and assists in search result navigation.
    // Serves as an index within the searchResults array.
    // Will be nil if no results available or no chapters available.
    private var resultIndex: Int?
    
    private let player: PlaybackDelegateProtocol = ObjectGraph.playbackDelegate
    
    // The chapters list window is only considered modal when it is the key window AND the search bar has focus
    // (i.e. a search is being performed)
    var isModal: Bool {
        return (self.view.window?.isKeyWindow ?? false) && isPerformingSearch
    }
    
    override func viewDidLoad() {
        
        scrollView.drawsBackground = false
        clipView.drawsBackground = false
        
        functionButtons = [btnPreviousChapter, btnNextChapter, btnReplayChapter, btnLoopChapter, btnCaseSensitive]
        
        btnClose.tintFunction = {return Colors.viewControlButtonColor}
        applyColorScheme(ColorSchemes.systemScheme)
        
        initHeader()
        
        // Set these fields for later access
        PlaylistViewState.chaptersListView = self.chaptersListView
        
        initSubscriptions()
        
        btnLoopChapter.off()
        
        lblNumMatches.stringValue = ""
        [btnPreviousMatch, btnNextMatch].forEach({$0?.disable()})
        
        WindowManager.registerModalComponent(self)
    }
    
    private func initHeader() {
        
        setHeaderHeight()
        header.wantsLayer = true
        header.layer?.backgroundColor = NSColor.black.cgColor
        
        chaptersListView.tableColumns.forEach({
            
            let col = $0
            let header = ChaptersListTableHeaderCell()
            
            header.stringValue = col.headerCell.stringValue
            header.isBordered = false
            
            col.headerCell = header
        })
    }
    
    private func setHeaderHeight() {
        
        header.setFrameSize(NSMakeSize(header.frame.size.width, header.frame.size.height + 5))
        clipView.setFrameSize(NSMakeSize(clipView.frame.size.width, clipView.frame.size.height + 5))
    }
    
    private func initSubscriptions() {
        
        Messenger.subscribe(self, .chapterChanged, self.chapterChanged(_:))
        
        Messenger.subscribe(self, .playbackLoopChanged, self.playbackLoopChanged)
        
        // Register self as a subscriber to synchronous message notifications
        Messenger.subscribeAsync(self, .trackTransition, self.trackChanged, queue: .main)
        
        Messenger.subscribe(self, .chaptersList_playSelectedChapter, self.playSelectedChapter)
        
        Messenger.subscribe(self, .changePlaylistTextSize, self.changeTextSize(_:))
        
        Messenger.subscribe(self, .colorScheme_applyColorScheme, self.applyColorScheme(_:))
        Messenger.subscribe(self, .colorScheme_changeBackgroundColor, self.changeBackgroundColor(_:))
        Messenger.subscribe(self, .colorScheme_changeViewControlButtonColor, self.changeViewControlButtonColor(_:))
        Messenger.subscribe(self, .colorScheme_changeFunctionButtonColor, self.changeFunctionButtonColor(_:))
        Messenger.subscribe(self, .colorScheme_changeToggleButtonOffStateColor, self.changeToggleButtonOffStateColor(_:))
        Messenger.subscribe(self, .colorScheme_changeMainCaptionTextColor, self.changeMainCaptionTextColor(_:))
        
        SyncMessenger.subscribe(actionTypes: [.changePlaylistSummaryInfoColor, .changePlaylistTrackNameTextColor, .changePlaylistIndexDurationTextColor, .changePlaylistTrackNameSelectedTextColor, .changePlaylistIndexDurationSelectedTextColor, .changePlaylistPlayingTrackIconColor, .changePlaylistSelectionBoxColor], subscriber: self)
    }
    
    override func viewDidAppear() {
        
        // Need to do this every time the view reappears (i.e. the Chapters list window is opened)
        chaptersListView.reloadData()
        
        let chapterCount: Int = player.chapterCount
        lblSummary.stringValue = String(format: "%d %@", chapterCount, chapterCount == 1 ? "chapter" : "chapters")
        
        lblWindowTitle.font = Fonts.Playlist.chaptersListCaptionFont
        lblSummary.font = Fonts.Playlist.summaryFont
        
        txtSearch.font = Fonts.Playlist.chapterSearchFont
        lblNumMatches.font = Fonts.Playlist.chapterSearchFont
        
        btnLoopChapter.onIf(player.chapterLoopExists)
        
        // Make sure the chapters list view has focus every time the window is opened
        self.view.window?.makeFirstResponder(chaptersListView)
    }
    
    // MARK: Playback functions
    
    @IBAction func playSelectedChapterAction(_ sender: AnyObject) {
        playSelectedChapter()
    }
    
    private func playSelectedChapter() {
        
        if let selRow = chaptersListView.selectedRowIndexes.first {
            
            Messenger.publish(.player_playChapter, payload: selRow)
            btnLoopChapter.onIf(player.chapterLoopExists)
            
            // Remove focus from the search field (if necessary)
            self.view.window?.makeFirstResponder(chaptersListView)
        }
    }
    
    @IBAction func playPreviousChapterAction(_ sender: AnyObject) {
        
        Messenger.publish(.player_previousChapter)
        btnLoopChapter.onIf(player.chapterLoopExists)
        
        // Remove focus from the search field (if necessary)
        self.view.window?.makeFirstResponder(chaptersListView)
    }
    
    @IBAction func playNextChapterAction(_ sender: AnyObject) {
        
        Messenger.publish(.player_nextChapter)
        btnLoopChapter.onIf(player.chapterLoopExists)
        
        // Remove focus from the search field (if necessary)
        self.view.window?.makeFirstResponder(chaptersListView)
    }
    
    @IBAction func replayCurrentChapterAction(_ sender: AnyObject) {
        
        // Should not do anything when no chapter is playing
        // (possible if chapters don't cover the entire timespan of the track)
        if player.playingChapter != nil {
            
            Messenger.publish(.player_replayChapter)
            btnLoopChapter.onIf(player.chapterLoopExists)
        }
        
        // Remove focus from the search field (if necessary)
        self.view.window?.makeFirstResponder(chaptersListView)
    }
    
    @IBAction func toggleCurrentChapterLoopAction(_ sender: AnyObject) {
        
        // Should not do anything when no chapter is playing
        // (possible if chapters don't cover the entire timespan of the track)
        if player.playingChapter != nil {
            
            // Toggle the loop
            Messenger.publish(.player_toggleChapterLoop)
            btnLoopChapter.onIf(player.chapterLoopExists)
        }
        
        // Remove focus from the search field (if necessary)
        self.view.window?.makeFirstResponder(chaptersListView)
    }
    
    // MARK: Search functions
    
    @IBAction func searchAction(_ sender: AnyObject) {
        
        let queryText = txtSearch.stringValue
        
        // Clear any previous search results
        searchResults.removeAll()
        
        // Ensure that there is some query text and that the playing track has some chapters
        if !queryText.isEmpty, let chapters = player.playingTrack?.chapters {
            
            // Compare the query text with all chapter titles
            for index in 0..<chapters.count {
                
                if compare(queryText, chapters[index].title) {
                    
                    // Append the row index for this chapter to the search results array
                    searchResults.append(index)
                }
            }
            
            let numResults: Int = searchResults.count
            let hasResults: Bool = numResults > 0
            
            // Select the first result or no row if no results
            chaptersListView.selectRowIndexes(IndexSet(hasResults ? [searchResults[0]] : []), byExtendingSelection: false)
            if hasResults {
                chaptersListView.scrollRowToVisible(searchResults[0])
            }
            
            resultIndex = hasResults ? 0 : nil
            
            // Update the search UI to indicate the number of results and allow navigation through them
            lblNumMatches.stringValue = String(format: "%d %@", numResults, numResults == 1 ? "match" : "matches")
            btnPreviousMatch.disable()
            btnNextMatch.enableIf(numResults > 1)
            
        } else {
            
            // No text or no track chapters
            lblNumMatches.stringValue = ""
            [btnPreviousMatch, btnNextMatch].forEach({$0?.disable()})
        }
    }
    
    @IBAction func toggleCaseSensitiveSearchAction(_ sender: AnyObject) {
        
        btnCaseSensitive.toggle()
        
        // Perform the search again
        searchAction(self)
    }
    
    // Navigate to the previous search result
    @IBAction func previousSearchResultAction(_ sender: AnyObject) {
        
        if let index = resultIndex, index > 0 {
            selectSearchResult(index - 1)
        }
    }
    
    // Navigate to the next search result
    @IBAction func nextSearchResultAction(_ sender: AnyObject) {
        
        if let index = resultIndex, index < searchResults.count - 1 {
            selectSearchResult(index + 1)
        }
    }
    
    /*
     Selects the given search result within the NSTableView
     
     @param index
     Index within the searchResults array (eg. first result, second result, etc)
     */
    private func selectSearchResult(_ index: Int) {
        
        // Select the search result and scroll to make it visible
        let row = searchResults[index]
        chaptersListView.selectRowIndexes(IndexSet([row]), byExtendingSelection: false)
        chaptersListView.scrollRowToVisible(row)
        
        resultIndex = index
        
        // Update the navigation buttons
        btnPreviousMatch.enableIf(resultIndex! > 0)
        btnNextMatch.enableIf(resultIndex! < searchResults.count - 1)
    }
    
    // Compares query text with a chapter title
    private func compare(_ queryText: String, _ chapterTitle: String) -> Bool {
        return btnCaseSensitive.isOn ? chapterTitle.contains(queryText) : chapterTitle.lowercased().contains(queryText.lowercased())
    }
    
    // Returns true if the search field has focus, false if not.
    private var isPerformingSearch: Bool {
        
        // Check if the search field has focus (i.e. it's the first responder of the Chapters list window)
        
        if let firstResponderView = self.view.window?.firstResponder as? NSView {
        
            // Iterate up the view hierarchy of the first responder view to see if any of its parent views
            // is the search field
            
            var curView: NSView? = firstResponderView
            while curView != nil {
                
                if curView === txtSearch {
                    return true
                }
                
                curView = curView?.superview
            }
        }
        
        return false
    }
    
    // MARK: Message handling
    
    func consumeMessage(_ message: ActionMessage) {
        
        if let colorSchemeMsg = message as? ColorSchemeComponentActionMessage {
            
            switch colorSchemeMsg.actionType {
                
            case .changePlaylistSummaryInfoColor:
                
                changeSummaryInfoColor(colorSchemeMsg.color)
                
            case .changePlaylistTrackNameTextColor:
                
                changeTrackNameTextColor(colorSchemeMsg.color)
                
            case .changePlaylistIndexDurationTextColor:
                
                changeIndexDurationTextColor(colorSchemeMsg.color)
                
            case .changePlaylistTrackNameSelectedTextColor:
                
                changeTrackNameSelectedTextColor(colorSchemeMsg.color)
                
            case .changePlaylistIndexDurationSelectedTextColor:
                
                changeIndexDurationSelectedTextColor(colorSchemeMsg.color)
                
            case .changePlaylistPlayingTrackIconColor:
                
                changePlayingTrackIconColor(colorSchemeMsg.color)
                
            case .changePlaylistSelectionBoxColor:
                
                changeSelectionBoxColor(colorSchemeMsg.color)
                
            default: return
                
            }
            
            return
        }
    }
    
    func trackChanged() {
        
        // Don't need to do this if the window is not visible
        if view.window?.isVisible ?? false {
            
            chaptersListView.reloadData()
            chaptersListView.scrollRowToVisible(0)
            
            let chapterCount: Int = player.chapterCount
            lblSummary.stringValue = String(format: "%d %@", chapterCount, chapterCount == 1 ? "chapter" : "chapters")
        }
        
        // This should always be done
        btnLoopChapter.onIf(player.chapterLoopExists)
        txtSearch.stringValue = ""
        lblNumMatches.stringValue = ""
        [btnPreviousMatch, btnNextMatch].forEach({$0?.disable()})
        resultIndex = nil
        searchResults.removeAll()
    }
    
    // When the currently playing chapter changes, the marker icon in the chapters list needs to move to the
    // new chapter.
    func chapterChanged(_ notification: ChapterChangedNotification) {
        
        // Don't need to do this if the window is not visible
        if let _window = view.window, _window.isVisible {
            
            let refreshRows: [Int] = [notification.oldChapter?.index, notification.newChapter?.index]
                .compactMap {$0}.filter({$0 >= 0})
            
            if !refreshRows.isEmpty {
                self.chaptersListView.reloadData(forRowIndexes: IndexSet(refreshRows), columnIndexes: [0])
            }
        }
        
        btnLoopChapter.onIf(player.chapterLoopExists)
    }
    
    // When the player's segment loop has been changed externally (from the player), it invalidates the chapter loop if there is one
    func playbackLoopChanged() {
        btnLoopChapter.onIf(player.chapterLoopExists)
    }
    
    private func changeTextSize(_ textSize: TextSize) {
        
        // Don't need to do this if the window is not visible
        if let _window = view.window, _window.isVisible {
            
            let selRows = chaptersListView.selectedRowIndexes
            chaptersListView.reloadData()
            chaptersListView.selectRowIndexes(selRows, byExtendingSelection: false)
            
            lblWindowTitle.font = Fonts.Playlist.chaptersListCaptionFont
            lblSummary.font = Fonts.Playlist.summaryFont
            
            txtSearch.font = Fonts.Playlist.chapterSearchFont
            lblNumMatches.font = Fonts.Playlist.chapterSearchFont
        }
    }
    
    private func applyColorScheme(_ scheme: ColorScheme) {
        
        changeBackgroundColor(scheme.general.backgroundColor)
        changeViewControlButtonColor(scheme.general.viewControlButtonColor)
        
        changeSummaryInfoColor(scheme.playlist.summaryInfoColor)
        changeMainCaptionTextColor(scheme.general.mainCaptionTextColor)
        
        changeFunctionButtonColor(scheme.general.functionButtonColor)
        
        redrawSearchField()
        
        chaptersListView.reloadData()
    }
    
    private func changeBackgroundColor(_ color: NSColor) {
        
        chaptersListView.backgroundColor = NSColor.clear
        header.redraw()
    }
    
    private func changeFunctionButtonColor(_ color: NSColor) {
        
        functionButtons.forEach({$0.reTint()})
        [btnPreviousMatch, btnNextMatch].forEach({$0?.reTint()})
    }
    
    private func changeViewControlButtonColor(_ color: NSColor) {
        btnClose.reTint()
    }
    
    private func changeToggleButtonOffStateColor(_ color: NSColor) {
        [btnLoopChapter, btnCaseSensitive].forEach({$0.reTint()})
    }
    
    private func changeSummaryInfoColor(_ color: NSColor) {
        
        [lblSummary, lblNumMatches].forEach({$0?.textColor = color})
        header.redraw()
    }
    
    private var allRows: IndexSet {
        return IndexSet(integersIn: 0..<chaptersListView.numberOfRows)
    }
    
    private func changeTrackNameTextColor(_ color: NSColor) {
        
        chaptersListView.reloadData(forRowIndexes: allRows, columnIndexes: IndexSet([1]))
        redrawSearchField()
    }
    
    private func redrawSearchField() {
        
        txtSearch.textColor = Colors.Playlist.trackNameTextColor
        
        if let cell: NSSearchFieldCell = txtSearch.cell as? NSSearchFieldCell {
            
            // This is a hack to force these cells to redraw
            cell.resetCancelButtonCell()
            cell.resetSearchButtonCell()
            
            // Tint the 2 cell images according to the appropriate color.
            cell.cancelButtonCell?.image = cell.cancelButtonCell?.image?.applyingTint(Colors.Playlist.trackNameTextColor)
            cell.searchButtonCell?.image = cell.searchButtonCell?.image?.applyingTint(Colors.Playlist.trackNameTextColor)
        }
        
        txtSearch.redraw()
    }
    
    private func changeIndexDurationTextColor(_ color: NSColor) {
        chaptersListView.reloadData(forRowIndexes: allRows, columnIndexes: IndexSet([0, 2, 3]))
    }
    
    private func changeTrackNameSelectedTextColor(_ color: NSColor) {
        chaptersListView.reloadData(forRowIndexes: chaptersListView.selectedRowIndexes, columnIndexes: IndexSet([1]))
    }
    
    private func changeIndexDurationSelectedTextColor(_ color: NSColor) {
        chaptersListView.reloadData(forRowIndexes: chaptersListView.selectedRowIndexes, columnIndexes: IndexSet([0, 2, 3]))
    }
    
    private func changeSelectionBoxColor(_ color: NSColor) {
        
        // Note down the selected rows, clear the selection, and re-select the originally selected rows (to trigger a repaint of the selection boxes)
        let selRows = chaptersListView.selectedRowIndexes
        
        if !selRows.isEmpty {
            
            chaptersListView.selectRowIndexes(IndexSet([]), byExtendingSelection: false)
            chaptersListView.selectRowIndexes(selRows, byExtendingSelection: false)
        }
    }
    
    private func changePlayingTrackIconColor(_ color: NSColor) {
        
        if let playingChapterIndex = player.playingChapter?.index {
            chaptersListView.reloadData(forRowIndexes: IndexSet([playingChapterIndex]), columnIndexes: IndexSet([0]))
        }
    }
    
    private func changeMainCaptionTextColor(_ color: NSColor) {
        lblWindowTitle.textColor = color
    }
}
