import Foundation

fileprivate let chapterPlaybackStartTimeMargin: Double = 0.01

// Chapter playback functions
extension PlaybackDelegate {
    
    func playChapter(_ index: Int) {
        
        // Validate track and index by checking the bounds of the chapters array
        if let track = playingTrack, track.hasChapters, index >= 0 && index < track.chapters.count {
            
            // Find the chapter with the given index and seek to its start time.
            // HACK: Add a little margin to the chapter start time to avoid overlap in chapters (except if the start time is zero).
            let startTime = track.chapters[index].startTime
            seekToTime(startTime + (startTime > 0 ? chapterPlaybackStartTimeMargin : 0))
            
            // Resume playback if paused
            resumeIfPaused()
        }
    }
    
    func previousChapter() {
        
        if let index = previousChapterIndex {
            playChapter(index)
        }
    }
    
    func nextChapter() {
        
        if let index = nextChapterIndex {
            playChapter(index)
        }
    }
    
    func replayChapter() {
        
        if let startTime = playingChapter?.chapter.startTime {
        
            // Seek to current chapter's start time
            seekToTime(startTime + (startTime > 0 ? chapterPlaybackStartTimeMargin : 0))
            
            // Resume playback if paused
            resumeIfPaused()
        }
    }
    
    func loopChapter() {
        
        if let chapter = playingChapter?.chapter {
            player.defineLoop(chapter.startTime, chapter.endTime)
        }
    }
    
    var chapterCount: Int {
        return playingTrack?.chapters.count ?? 0
    }
    
    // NOTE - This property getter needs to be efficient because it is repeatedly called to keep track of the current chapter
    var playingChapter: IndexedChapter? {
        
        if let track = playingTrack, let index = currentChapterIndex {
            return IndexedChapter(track, track.chapters[index], index)
        }
        
        return nil
    }
    
    var currentChapterIndex: Int? {
        
        if let chapters = playingTrack?.chapters, !chapters.isEmpty {
            
            let seekTime = player.seekPosition
            
            // Binary search algorithm (assumes chapters are chronologically arranged and non-overlapping).
            // Able to handle gaps around chapters.
            
            var first = 0
            var last = chapters.count - 1
            var center = (first + last) / 2
            var centerChapter = chapters[center]
            
            while first <= last {
                
                if centerChapter.containsTimePosition(seekTime) {
                    
                    // Found a matching chapter
                    return center
                    
                } else if seekTime < centerChapter.startTime {
                    
                    last = center - 1
                    
                } else if seekTime > centerChapter.endTime {
                    
                    first = center + 1
                }
                
                center = (first + last) / 2
                centerChapter = chapters[center]
            }
        }
        
        return nil
    }
    
    var previousChapterIndex: Int? {
        
        if let chapters = playingTrack?.chapters, !chapters.isEmpty {
            
            let seekTime = player.seekPosition
            
            // Binary search algorithm (assumes chapters are chronologically arranged and non-overlapping).
            // Able to handle gaps around chapters.
            
            var first = 0
            var last = chapters.count - 1
            var center = (first + last) / 2
            var centerChapter = chapters[center]
            
            while first <= last {
                
                if centerChapter.containsTimePosition(seekTime) {
                    
                    // Found a matching chapter
                    return center - 1 < 0 ? nil : center - 1
                    
                } else if seekTime < centerChapter.startTime {
                    
                    last = center - 1
                    
                } else if seekTime > centerChapter.endTime {
                    
                    first = center + 1
                }
                
                center = (first + last) / 2
                centerChapter = chapters[center]
            }
            
            // If no matching chapter was found for the current seek position, try to determine a previous chapter.
            if seekTime < centerChapter.startTime {
                
                return center - 1 < 0 ? nil : center - 1
                
            } else {
                
                return center
            }
        }
        
        return nil
    }
    
    var nextChapterIndex: Int? {
        
        if let chapters = playingTrack?.chapters, !chapters.isEmpty {
            
            let seekTime = player.seekPosition
            
            // Binary search algorithm (assumes chapters are chronologically arranged and non-overlapping).
            // Able to handle gaps around chapters.
            
            var first = 0
            var last = chapters.count - 1
            var center = (first + last) / 2
            var centerChapter = chapters[center]
            
            while first <= last {
                
                if centerChapter.containsTimePosition(seekTime) {
                    
                    // Found a matching chapter
                    return center + 1 >= chapters.count ? nil : center + 1
                    
                } else if seekTime < centerChapter.startTime {
                    
                    last = center - 1
                    
                } else if seekTime > centerChapter.endTime {
                    
                    first = center + 1
                }
                
                center = (first + last) / 2
                centerChapter = chapters[center]
            }
            
            // If no matching chapter was found for the current seek position, try to determine a next chapter.
            if seekTime < centerChapter.startTime {
                
                return center
                
            } else {
                
                return center + 1 >= chapters.count ? nil : center + 1
            }
        }
        
        return nil
    }
}