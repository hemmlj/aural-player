import XCTest

class PlaybackSequenceIterationTests: AuralTestCase {
    
    //    override var runLongRunningTests: Bool {return true}
    
    private var sequence: PlaybackSequence = PlaybackSequence(.off, .off)
    
    override func setUp() {
        sequence.clear()
    }
    
    private var repeatShufflePermutations: [(repeatMode: RepeatMode, shuffleMode: ShuffleMode)] {
        
        var array: [(repeatMode: RepeatMode, shuffleMode: ShuffleMode)] = []
        
        for repeatMode in RepeatMode.allCases {
            
            for shuffleMode in ShuffleMode.allCases {
                
                // Repeat One / Shuffle On is not a valid permutation
                if (repeatMode, shuffleMode) != (.one, .on) {
                    array.append((repeatMode, shuffleMode))
                }
            }
        }
        
        return array
    }
    
    // MARK: subsequent() tests -----------------------------------------------------------------------------------------------
    
    // A function that, given the size and start index of a sequence ... produces a sequence of indices in the order that they should be
    // produced by calls to any of the iteration functions e.g. subsequent(), previous(), etc. This is passed from a test function
    // to a helper function to set the right expectations for the test.
    fileprivate typealias ExpectedIndicesFunction = (_ size: Int, _ startIndex: Int?) -> [Int?]
    
    func testSubsequent_repeatOff_shuffleOff_withPlayingTrack() {
        
        doTestSubsequent(true, .off, .off, {(size: Int, startIndex: Int?) -> [Int?] in
            
            // When there is a playing track, startIndex cannot be nil.
            XCTAssertNotNil(startIndex)
            
            // Because there is a playing track (represented by startIndex), the test should start at startIndex + 1.
            var subsequentIndices: [Int?] = size == 1 ? [] : Array((startIndex! + 1)..<size)
            
            // Test that:
            // 1 - after the last track (i.e. at the end of the sequence), nil is returned.
            // 2 - after the sequence has ended and nil is returned, the following call to subsequent() should return 0 because the sequence restarts.
            // 3 - the sequence should then repeat again sequentially: 0, 1, 2, ...
            subsequentIndices.append(nil)
            subsequentIndices += Array(0..<size)
            
            // The test results should look like this:
            // startIndex + 1, startIndex + 2, ..., (n - 1), nil, 0, 1, 2, ... (n - 1), where n is the size of the array
            
            return subsequentIndices
        })
    }
    
    func testSubsequent_repeatOff_shuffleOff_noPlayingTrack() {
        
        doTestSubsequent(false, .off, .off, {(size: Int, startIndex: Int?) -> [Int?] in
            
            // Because there is no playing track, the test should start at 0 and contain the entire sequence.
            var subsequentIndices: [Int?] = Array(0..<size)
            
            // Test that:
            // 1 - after the last track (i.e. at the end of the sequence), nil is returned.
            // 2 - after the sequence has ended and nil is returned, the following call to subsequent() should return 0 because the sequence restarts.
            // 3 - the sequence should then repeat again sequentially: 0, 1, 2, ...
            subsequentIndices.append(nil)
            subsequentIndices += Array(0..<size)
            
            // The test results should look like this:
            // 0, 1, 2, ..., (n - 1), nil, 0, 1, 2, ... (n - 1), where n is the size of the array
            
            return subsequentIndices
        })
    }
    
    func testSubsequent_repeatOne_shuffleOff_withPlayingTrack() {
        
        doTestSubsequent(true, .one, .off, {(size: Int, startIndex: Int?) -> [Int?] in
            
            // When there is a playing track, startIndex cannot be nil.
            XCTAssertNotNil(startIndex)
            
            // When there is a playing track (represented by startIndex), the first call to subsequent()
            // should produce the same track, i.e. startIndex. Repeated subsequent() calls should also
            // produce startIndex indefinitely.
            return Array(repeating: startIndex!, count: 10000)
        })
    }
    
    func testSubsequent_repeatOne_shuffleOff_noPlayingTrack() {
        
        doTestSubsequent(false, .one, .off, {(size: Int, startIndex: Int?) -> [Int?] in
            
            // When there is no playing track, the first call to subsequent() should produce the first track, i.e. index 0.
            // Repeated subsequent() calls should also produce 0 indefinitely.
            return Array(repeating: 0, count: 10000)
        })
    }
    
    func testSubsequent_repeatAll_shuffleOff_withPlayingTrack() {
        
        doTestSubsequent(true, .all, .off, {(size: Int, startIndex: Int?) -> [Int?] in
            
            // When there is a playing track, startIndex cannot be nil.
            XCTAssertNotNil(startIndex)
            
            // Because there is a playing track (represented by startIndex), the test should start at startIndex + 1.
            
            // The test results should look like this:
            // startIndex + 1, startIndex + 2, ..., (n - 1), 0, 1, 2, ... (n - 1), where n is the size of the array.
            
            return size == 1 ? [] : Array((startIndex! + 1)..<size)
            
        }, 10)
    }
    
    func testSubsequent_repeatAll_shuffleOff_noPlayingTrack() {
        
        doTestSubsequent(false, .all, .off, {(size: Int, startIndex: Int?) -> [Int?] in
            
            // Because there is no playing track, the test should start at 0 and contain the entire sequence.
            
            // The test results should look like this:
            // 0, 1, 2, ..., (n - 1), 0, 1, 2, ... (n - 1), 0, 1, 2, ... (n - 1), where n is the size of the array.
            
            return Array(0..<size)
            
        }, 10)
    }
    
    func testSubsequent_repeatOff_shuffleOn_withPlayingTrack() {
        
        doTestSubsequent(true, .off, .on, {(size: Int, startIndex: Int?) -> [Int?] in
            
            // When there is a playing track, startIndex cannot be nil.
            XCTAssertNotNil(startIndex)
            
            // The sequence of elements produced by calls to subsequent() should match the shuffle sequence array,
            // starting with its 2nd element (the first element is already playing).
            var subsequentIndices: [Int?] = sequence.shuffleSequence.sequence.suffix(size - 1)
            
            // Test that after the last track (i.e. at the end of the sequence), nil is returned.
            subsequentIndices.append(nil)
            
            return subsequentIndices
        })
    }
    
    func testSubsequent_repeatOff_shuffleOn_noPlayingTrack() {
        
        doTestSubsequent(false, .off, .on, {(size: Int, startIndex: Int?) -> [Int?] in
            
            // The sequence of elements produced by calls to subsequent() should exactly match the shuffle sequence array.
            var subsequentIndices: [Int?] = Array(sequence.shuffleSequence.sequence)
            
            // Test that after the last track (i.e. at the end of the sequence), nil is returned.
            subsequentIndices.append(nil)
            
            return subsequentIndices
        })
    }
    
    func testSubsequent_repeatAll_shuffleOn_withPlayingTrack() {
        
        doTestSubsequent(true, .all, .on, {(size: Int, startIndex: Int?) -> [Int?] in
            
            // The sequence of elements produced by calls to subsequent() should exactly match
            // the shuffle sequence array (minus the first element, which represents the already
            // playing track)
            return Array(sequence.shuffleSequence.sequence.suffix(size - 1))
            
        }, 10)   // Repeat sequence iteration 10 times to test repeat all.
    }
    
    func testSubsequent_repeatAll_shuffleOn_noPlayingTrack() {
        
        doTestSubsequent(false, .all, .on, {(size: Int, startIndex: Int?) -> [Int?] in
            
            // The sequence of elements produced by calls to subsequent() should exactly match
            // the shuffle sequence array.
            return Array(sequence.shuffleSequence.sequence)
            
        }, 10)  // Repeat sequence iteration 10 times to test repeat all.
    }
    
    private func doTestSubsequent(_ hasPlayingTrack: Bool, _ repeatMode: RepeatMode, _ shuffleMode: ShuffleMode, _ expectedIndicesFunction: ExpectedIndicesFunction, _ repeatCount: Int = 0) {
        
        var randomSizes: [Int] = [1, 2, 3, 4]
        
        for _ in 1...100 {
            randomSizes.append(Int.random(in: 5...10000))
        }
        
        for size in randomSizes {
            
            var startIndices: Set<Int?> = Set()
            
            // Select a random start index (playing track index).
            if hasPlayingTrack {
                
                // These 2 indices are essential for testing and should always be present.
                startIndices.insert(0)
                startIndices.insert(size - 1)
                
                // Select up to 10 other random indices for the test
                for _ in 1...min(size, 10) {
                    startIndices.insert(size == 1 ? 0 : Int.random(in: 0..<size))
                }
                
            } else {
                startIndices.insert(nil)
            }
            
            for startIndex in startIndices {
                
                initSequence(size, startIndex, repeatMode, shuffleMode)
                
                // Exercise the given indices function to obtain an array of expected results from repeated calls to subsequent().
                // NOTE - The size of the expectedIndices array will determine how many times subsequent() will be called (and tested).
                let expectedIndices: [Int?] = expectedIndicesFunction(size, startIndex)
                
                // For each expected index value, call subsequent() and match its return value.
                for value in expectedIndices {
                    
                    XCTAssertEqual(sequence.subsequent(), value)
                    
                    // Also verify that the sequence is now pointing at this new value (i.e. iteration took place)
                    XCTAssertEqual(sequence.curTrackIndex, value)
                }
                
                // When repeatMode = .all, the sequence will be restarted the next time subsequent() is called.
                // If a repeatCount is given, perform further testing by looping through the sequence again.
                if repeatCount > 0 && repeatMode == .all {
                    
                    if shuffleMode == .on {
                        
                        // This test is not meaningful for very small sequences.
                        if size >= 3 {
                            doTestSubsequent_sequenceRestart_repeatAll_shuffleOn(repeatCount)
                        }
                        
                    } else {
                        
                        doTestSubsequent_sequenceRestart_repeatAll_shuffleOff(repeatCount)
                    }
                }
            }
        }
    }
    
    // Loop around to the beginning of the sequence and iterate through it.
    private func doTestSubsequent_sequenceRestart_repeatAll_shuffleOff(_ repeatCount: Int) {
        
        let sequenceRange: Range<Int> = 0..<sequence.size
        
        for _ in 1...repeatCount {
            
            // Iterate through the same sequence again, from the beginning, and verify that calls to subsequent()
            // produce the same sequence again.
            for value in sequenceRange {
                
                XCTAssertEqual(sequence.subsequent(), value)
                
                // Also verify that the sequence is now pointing at this new value (i.e. iteration took place)
                XCTAssertEqual(sequence.curTrackIndex, value)
            }
        }
    }
    
    // Helper function that iterates through an entire shuffle sequence, testing that calls to
    // subsequent() produce values matching the sequence. Based on the given repeatCount,
    // the iteration through the sequence is repeated a number of times so that multiple new
    // sequences are created (as a result of the repeat all setting).
    //
    // firstShuffleSequence is used for comparison to the new sequence created when it ends.
    // As each following sequence ends, a new one is created (because of the repeat all setting).
    // Need to ensure that each new sequence differs from the last.
    private func doTestSubsequent_sequenceRestart_repeatAll_shuffleOn(_ repeatCount: Int) {
        
        // Start the loop with firstShuffleSequence
        var previousShuffleSequence: [Int] = Array(sequence.shuffleSequence.sequence)
        let size: Int = previousShuffleSequence.count
        
        // Each loop iteration will trigger the creation of a new shuffle sequence, and iterate through it.
        for _ in 1...repeatCount {
            
            // NOTE - The first element of the new shuffle sequence cannot be predicted, but it suffices to test that it is
            // non-nil and that it differs from the last element of the first sequence (this is by requirement).
            let firstElementOfNewSequence: Int? = sequence.subsequent()
            XCTAssertNotNil(firstElementOfNewSequence)
            
            // If there is only one element in the sequence, this comparison is not valid.
            if size > 1 {
                XCTAssertNotEqual(firstElementOfNewSequence, previousShuffleSequence.last)
            }
            
            // Capture the newly created sequence, and ensure it's of the same size as the previous one.
            let newShuffleSequence = Array(sequence.shuffleSequence.sequence)
            XCTAssertEqual(newShuffleSequence.count, previousShuffleSequence.count)
            
            // Test that the newly created shuffle sequence differs from the last one, if it is sufficiently large.
            // NOTE - For small sequences, the new sequence might co-incidentally be the same as the first one.
            if size >= 10 {
                XCTAssertFalse(newShuffleSequence.elementsEqual(previousShuffleSequence))
            }
            
            // Now, ensure that the following calls to subsequent() produce a sequence matching the new shuffle sequence (minus the first element).
            // NOTE - Skip the first element which has already been produced and tested.
            for value in newShuffleSequence.suffix(size - 1) {
                
                XCTAssertEqual(sequence.subsequent(), value)
                
                // Also verify that the sequence is now pointing at this new value (i.e. iteration took place)
                XCTAssertEqual(sequence.curTrackIndex, value)
            }
            
            // Update the previousShuffleSequence variable with the new sequence, to be used for comparison in the next loop iteration.
            previousShuffleSequence = newShuffleSequence
        }
    }
    
    private func initSequence(_ size: Int, _ startingTrackIndex: Int?, _ repeatMode: RepeatMode, _ shuffleMode: ShuffleMode) {
        
        sequence.clear()
        
        _ = sequence.setRepeatMode(repeatMode)
        let modes = sequence.setShuffleMode(shuffleMode)
        XCTAssertTrue(modes == (repeatMode, shuffleMode))
        
        if size > 0 {
            
            sequence.resizeAndStart(size: size, withTrackIndex: startingTrackIndex)
            
            // Verify the size and current track index.
            XCTAssertEqual(sequence.size, size)
            XCTAssertEqual(sequence.curTrackIndex, startingTrackIndex)
        }
    }
    
    func testSubsequent_repeatOff_shuffleOff_emptySequence() {
        doTestSubsequent_emptySequence(.off, .off)
    }
    
    func testSubsequent_repeatOne_shuffleOff_emptySequence() {
        doTestSubsequent_emptySequence(.one, .off)
    }
    
    func testSubsequent_repeatAll_shuffleOff_emptySequence() {
        doTestSubsequent_emptySequence(.all, .off)
    }
    
    func testSubsequent_repeatOff_shuffleOn_emptySequence() {
        doTestSubsequent_emptySequence(.off, .on)
    }
    
    func testSubsequent_repeatAll_shuffleOn_emptySequence() {
        doTestSubsequent_emptySequence(.all, .on)
    }
    
    private func doTestSubsequent_emptySequence(_ repeatMode: RepeatMode, _ shuffleMode: ShuffleMode) {
        
        // Create and verify an empty sequence.
        initSequence(0, nil, repeatMode, shuffleMode)
        XCTAssertEqual(sequence.size, 0)
        XCTAssertEqual(sequence.curTrackIndex, nil)
        
        // Repeated calls to subsequent() should all produce nil.
        for _ in 1...10 {
            
            XCTAssertNil(sequence.subsequent())
            
            // Ensure that no resizing/iteration has taken place.
            XCTAssertEqual(sequence.size, 0)
            XCTAssertEqual(sequence.curTrackIndex, nil)
        }
    }
    
    // MARK: next() tests ------------------------------------------------------------------------------
    
    func testNext_repeatOff_shuffleOff_withPlayingTrack() {
        
        doTestNext(.off, .off, {(size: Int, startIndex: Int?) -> [Int?] in
            
            // When there is a playing track, startIndex cannot be nil.
            XCTAssertNotNil(startIndex)
            
            // If there aren't at least 2 tracks in the sequence, next() should always produce nil, even with repeated calls.
            if size < 2 {return Array(repeating: nil, count: 10)}
            
            // Because there is a playing track (represented by startIndex), the test should start at startIndex + 1.
            var nextIndices: [Int?] = Array((startIndex! + 1)..<size)
            
            // Test that after the last track (i.e. at the end of the sequence), nil should be returned, even with repeated calls.
            nextIndices += Array(repeating: nil, count: 10)
            
            // The test results should look like this:
            // startIndex + 1, startIndex + 2, ..., (n - 1), nil, nil, nil, ... where n is the size of the array
            
            return nextIndices
        })
    }
    
    func testNext_repeatOff_shuffleOff_noPlayingTrack() {
        
        for size in [1, 2, 3, 5, 10, 100, 500, 1000, 5000, 10000] {
            
            initSequence(size, nil, .off, .off)
            
            // When no track is currently playing, nil should be returned, even with repeated calls.
            for _ in 1...10 {
                
                XCTAssertNil(sequence.next())
                
                // Also ensure that the sequence is still not pointing to any particular element (i.e. no iteration)
                XCTAssertNil(sequence.curTrackIndex)
            }
        }
    }
    
    func testNext_repeatOne_shuffleOff_withPlayingTrack() {
        
        doTestNext(.one, .off, {(size: Int, startIndex: Int?) -> [Int?] in
            
            // When there is a playing track, startIndex cannot be nil.
            XCTAssertNotNil(startIndex)
            
            // If there aren't at least 2 tracks in the sequence, next() should always produce nil, even with repeated calls.
            if size < 2 {return Array(repeating: nil, count: 10)}
            
            // Because there is a playing track (represented by startIndex), the test should start at startIndex + 1.
            var nextIndices: [Int?] = Array((startIndex! + 1)..<size)
            
            // Test that after the last track (i.e. at the end of the sequence), nil should be returned, even with repeated calls.
            nextIndices += Array(repeating: nil, count: 10)
            
            // The test results should look like this:
            // startIndex + 1, startIndex + 2, ..., (n - 1), nil, nil, nil, ... where n is the size of the array
            
            return nextIndices
        })
    }
    
    func testNext_repeatOne_shuffleOff_noPlayingTrack() {
        
        for size in [1, 2, 3, 5, 10, 100, 500, 1000, 5000, 10000] {
            
            initSequence(size, nil, .one, .off)
            
            // When no track is currently playing, nil should be returned, even with repeated calls.
            for _ in 1...10 {
                
                XCTAssertNil(sequence.next())
                
                // Also ensure that the sequence is still not pointing to any particular element (i.e. no iteration)
                XCTAssertNil(sequence.curTrackIndex)
            }
        }
    }
    
    func testNext_repeatAll_shuffleOff_withPlayingTrack() {
        
        doTestNext(.all, .off, {(size: Int, startIndex: Int?) -> [Int?] in
            
            // When there is a playing track, startIndex cannot be nil.
            XCTAssertNotNil(startIndex)
            
            // If there aren't at least 2 tracks in the sequence, next() should always produce nil, even with repeated calls.
            if size < 2 {return Array(repeating: nil, count: 10)}
            
            // Because there is a playing track (represented by startIndex), the test should start at startIndex + 1.
            
            // The test results should look like this:
            // startIndex + 1, startIndex + 2, ..., (n - 1), 0, 1, 2, ... (n - 1), where n is the size of the array.
            
            return Array((startIndex! + 1)..<size)
            
        }, 10)
    }
    
    func testNext_repeatAll_shuffleOff_noPlayingTrack() {
        
        for size in [1, 2, 3, 5, 10, 100, 500, 1000, 5000, 10000] {
            
            initSequence(size, nil, .all, .off)
            
            // When no track is currently playing, nil should be returned, even with repeated calls.
            for _ in 1...10 {
                
                XCTAssertNil(sequence.next())
                
                // Also ensure that the sequence is still not pointing to any particular element (i.e. no iteration)
                XCTAssertNil(sequence.curTrackIndex)
            }
        }
    }
    
    func testNext_repeatOff_shuffleOn_withPlayingTrack() {
        
        doTestNext(.off, .on, {(size: Int, startIndex: Int?) -> [Int?] in
            
            // The sequence of elements produced by calls to next() should match the shuffle sequence array,
            // starting with its 2nd element (the first element is already playing).
            var nextIndices: [Int?] = sequence.shuffleSequence.sequence.suffix(size - 1)
            
            // Test that after the last track (i.e. at the end of the sequence), nil is returned, even with repeated calls.
            nextIndices += Array(repeating: nil, count: 10)
            
            return nextIndices
        })
    }
    
    func testNext_repeatOff_shuffleOn_noPlayingTrack() {
        
        for size in [1, 2, 3, 5, 10, 100, 500, 1000, 5000, 10000] {
            
            initSequence(size, nil, .off, .on)
            
            // When no track is currently playing, nil should be returned, even with repeated calls.
            for _ in 1...10 {
                
                XCTAssertNil(sequence.next())
                
                // Also ensure that the sequence is still not pointing to any particular element (i.e. no iteration)
                XCTAssertNil(sequence.curTrackIndex)
            }
        }
    }
    
    func testNext_repeatAll_shuffleOn_withPlayingTrack() {
        
        doTestNext(.all, .on, {(size: Int, startIndex: Int?) -> [Int?] in
            
            // The sequence of elements produced by calls to next() should exactly match
            // the shuffle sequence array (minus the first element, which represents the already
            // playing track)
            return Array(sequence.shuffleSequence.sequence.suffix(size - 1))
            
        }, 10)   // Repeat sequence iteration 10 times to test repeat all.
    }
    
    func testNext_repeatAll_shuffleOn_noPlayingTrack() {
        
        for size in [1, 2, 3, 5, 10, 100, 500, 1000, 5000, 10000] {
            
            initSequence(size, nil, .all, .on)
            
            // When no track is currently playing, nil should be returned, even with repeated calls.
            for _ in 1...10 {
                
                XCTAssertNil(sequence.next())
                
                // Also ensure that the sequence is still not pointing to any particular element (i.e. no iteration)
                XCTAssertNil(sequence.curTrackIndex)
            }
        }
    }
    
    private func doTestNext(_ repeatMode: RepeatMode, _ shuffleMode: ShuffleMode, _ expectedIndicesFunction: ExpectedIndicesFunction, _ repeatCount: Int = 0) {
        
        var randomSizes: [Int] = [1, 2, 3, 4]
        
        for _ in 1...100 {
            randomSizes.append(Int.random(in: 5...10000))
        }
        
        for size in randomSizes {
            
            var startIndices: Set<Int> = Set()
            
            // These 2 indices are essential for testing and should always be present.
            startIndices.insert(0)
            startIndices.insert(size - 1)
            
            // Select up to 10 other random indices for the test
            for _ in 1...min(size, 10) {
                startIndices.insert(size == 1 ? 0 : Int.random(in: 0..<size))
            }
            
            for startIndex in startIndices {
                
                initSequence(size, startIndex, repeatMode, shuffleMode)
                
                // Exercise the given indices function to obtain an array of expected results from repeated calls to next().
                // NOTE - The size of the expectedIndices array will determine how many times next() will be called (and tested).
                let expectedIndices: [Int?] = expectedIndicesFunction(size, startIndex)
                
                // For each expected index value, call next() and match its return value.
                for expectedIndex in expectedIndices {
                    
                    // Capture the current sequence index before calling next()
                    let indexBeforeNext = sequence.curTrackIndex
                    
                    XCTAssertEqual(sequence.next(), expectedIndex)
                    
                    // Also verify that,
                    // if next() produced a non-nil value, the sequence is now pointing at this new value (i.e. iteration took place)
                    // OR
                    // if next() produced nil, the sequence is pointing at the same value it was pointing to before the call to next()
                    // (i.e. no iteration took place)
                    XCTAssertEqual(sequence.curTrackIndex, expectedIndex != nil ? expectedIndex : indexBeforeNext)
                }
                
                // When repeatMode = .all, the sequence will be restarted the next time subsequent() is called.
                // If a repeatCount is given, perform further testing by looping through the sequence again.
                if repeatCount > 0 && repeatMode == .all {
                    
                    if shuffleMode == .on {
                        
                        // This test is not meaningful for very small sequences.
                        if size >= 3 {
                            doTestNext_sequenceRestart_repeatAll_shuffleOn(repeatCount)
                        }
                        
                    } else {
                        
                        // For sequences with only one element, this test is not relevant.
                        if size > 1 {
                            doTestNext_sequenceRestart_repeatAll_shuffleOff(repeatCount)
                        }
                    }
                }
            }
        }
    }
    
    // Loop around to the beginning of the sequence and iterate through it.
    private func doTestNext_sequenceRestart_repeatAll_shuffleOff(_ repeatCount: Int) {
        
        let sequenceRange: Range<Int> = 0..<sequence.size
        
        for _ in 1...repeatCount {
            
            // Iterate through the same sequence again, from the beginning, and verify that calls to next()
            // produce the same sequence again.
            for value in sequenceRange {
                
                XCTAssertEqual(sequence.next(), value)
                
                // Also verify that the sequence is now pointing at this new value (i.e. iteration took place)
                XCTAssertEqual(sequence.curTrackIndex, value)
            }
        }
    }
    
    // Helper function that iterates through an entire shuffle sequence, testing that calls to
    // next() produce values matching the sequence. Based on the given repeatCount,
    // the iteration through the sequence is repeated a number of times so that multiple new
    // sequences are created (as a result of the repeat all setting).
    //
    // firstShuffleSequence is used for comparison to the new sequence created when it ends.
    // As each following sequence ends, a new one is created (because of the repeat all setting).
    // Need to ensure that each new sequence differs from the last.
    private func doTestNext_sequenceRestart_repeatAll_shuffleOn(_ repeatCount: Int) {
        
        // Start the loop with firstShuffleSequence
        var previousShuffleSequence: [Int] = Array(sequence.shuffleSequence.sequence)
        let size: Int = previousShuffleSequence.count
        
        // Each loop iteration will trigger the creation of a new shuffle sequence, and iterate through it.
        for _ in 1...repeatCount {
            
            // NOTE - The first element of the new shuffle sequence cannot be predicted, but it suffices to test that it is
            // non-nil and that it differs from the last element of the first sequence (this is by requirement).
            let firstElementOfNewSequence: Int? = sequence.next()
            XCTAssertNotNil(firstElementOfNewSequence)
            
            // If there is only one element in the sequence, this comparison is not valid.
            if size > 1 {
                XCTAssertNotEqual(firstElementOfNewSequence, previousShuffleSequence.last)
            }
            
            // Capture the newly created sequence, and ensure it's of the same size as the previous one.
            let newShuffleSequence = Array(sequence.shuffleSequence.sequence)
            XCTAssertEqual(newShuffleSequence.count, previousShuffleSequence.count)
            
            // Test that the newly created shuffle sequence differs from the last one, if it is sufficiently large.
            // NOTE - For small sequences, the new sequence might co-incidentally be the same as the first one.
            if size >= 10 {
                XCTAssertFalse(newShuffleSequence.elementsEqual(previousShuffleSequence))
            }
            
            // Now, ensure that the following calls to next() produce a sequence matching the new shuffle sequence (minus the first element).
            // NOTE - Skip the first element which has already been produced and tested.
            for value in newShuffleSequence.suffix(size - 1) {
                
                XCTAssertEqual(sequence.next(), value)
                
                // Also verify that the sequence is now pointing at this new value (i.e. iteration took place)
                XCTAssertEqual(sequence.curTrackIndex, value)
            }
            
            // Update the previousShuffleSequence variable with the new sequence, to be used for comparison in the next loop iteration.
            previousShuffleSequence = newShuffleSequence
        }
    }
    
    func testNext_repeatOff_shuffleOff_emptySequence() {
        doTestNext_emptySequence(.off, .off)
    }
    
    func testNext_repeatOne_shuffleOff_emptySequence() {
        doTestNext_emptySequence(.one, .off)
    }
    
    func testNext_repeatAll_shuffleOff_emptySequence() {
        doTestNext_emptySequence(.all, .off)
    }
    
    func testNext_repeatOff_shuffleOn_emptySequence() {
        doTestNext_emptySequence(.off, .on)
    }
    
    func testNext_repeatAll_shuffleOn_emptySequence() {
        doTestNext_emptySequence(.all, .on)
    }
    
    private func doTestNext_emptySequence(_ repeatMode: RepeatMode, _ shuffleMode: ShuffleMode) {
        
        // Create and verify an empty sequence.
        initSequence(0, nil, repeatMode, shuffleMode)
        XCTAssertEqual(sequence.size, 0)
        XCTAssertEqual(sequence.curTrackIndex, nil)
        
        // Repeated calls to next() should all produce nil.
        for _ in 1...10 {
            
            XCTAssertNil(sequence.next())
            
            // Ensure that no resizing/iteration has taken place.
            XCTAssertEqual(sequence.size, 0)
            XCTAssertEqual(sequence.curTrackIndex, nil)
        }
    }
    
    // MARK: previous() tests ------------------------------------------------------------------------------
    
    func testPrevious_repeatOff_shuffleOff_withPlayingTrack() {
        
        doTestPrevious_noShuffle(.off, {(size: Int, startIndex: Int?) -> [Int?] in
            
            // When there is a playing track, startIndex cannot be nil.
            XCTAssertNotNil(startIndex)
            
            // If there aren't at least 2 tracks in the sequence, previous() should always produce nil, even with repeated calls.
            if size < 2 {return Array(repeating: nil, count: 10)}
            
            // Because there is a playing track (represented by startIndex), the test should start at startIndex - 1.
            var previousIndices: [Int?] = Array((0..<startIndex!).reversed())
            
            // Test that once the first track has been reached (i.e. at the beginning of the sequence), nil should be returned, even with repeated calls.
            previousIndices += Array(repeating: nil, count: 10)
            
            // The test results should look like this:
            // startIndex - 1, startIndex - 2, ..., 0, nil, nil, nil, ...
            
            return previousIndices
        })
    }
    
    func testPrevious_repeatOff_shuffleOff_noPlayingTrack() {
        
        for size in [1, 2, 3, 5, 10, 100, 500, 1000, 5000, 10000] {
            
            initSequence(size, nil, .off, .off)
            
            // When no track is currently playing, nil should be returned, even with repeated calls.
            for _ in 1...10 {
                
                XCTAssertNil(sequence.previous())
                
                // Also ensure that the sequence is still not pointing to any particular element (i.e. no iteration)
                XCTAssertNil(sequence.curTrackIndex)
            }
        }
    }
    
    func testPrevious_repeatOne_shuffleOff_withPlayingTrack() {
        
        doTestPrevious_noShuffle(.one, {(size: Int, startIndex: Int?) -> [Int?] in
            
            // When there is a playing track, startIndex cannot be nil.
            XCTAssertNotNil(startIndex)
            
            // If there aren't at least 2 tracks in the sequence, previous() should always produce nil, even with repeated calls.
            if size < 2 {return Array(repeating: nil, count: 10)}
            
            // Because there is a playing track (represented by startIndex), the test should start at startIndex - 1.
            var previousIndices: [Int?] = Array((0..<startIndex!).reversed())
            
            // Test that once the first track has been reached (i.e. at the beginning of the sequence), nil should be returned, even with repeated calls.
            previousIndices += Array(repeating: nil, count: 10)
            
            // The test results should look like this:
            // startIndex - 1, startIndex - 2, ..., 0, nil, nil, nil, ...
            
            return previousIndices
        })
    }
    
    func testPrevious_repeatOne_shuffleOff_noPlayingTrack() {
        
        for size in [1, 2, 3, 5, 10, 100, 500, 1000, 5000, 10000] {
            
            initSequence(size, nil, .one, .off)
            
            // When no track is currently playing, nil should be returned, even with repeated calls.
            for _ in 1...10 {
                
                XCTAssertNil(sequence.previous())
                
                // Also ensure that the sequence is still not pointing to any particular element (i.e. no iteration)
                XCTAssertNil(sequence.curTrackIndex)
            }
        }
    }
    
    func testPrevious_repeatAll_shuffleOff_withPlayingTrack() {
        
        doTestPrevious_noShuffle(.all, {(size: Int, startIndex: Int?) -> [Int?] in
            
            // When there is a playing track, startIndex cannot be nil.
            XCTAssertNotNil(startIndex)
            
            // If there aren't at least 2 tracks in the sequence, previous() should always produce nil, even with repeated calls.
            if size < 2 {return Array(repeating: nil, count: 10)}
            
            // Because there is a playing track (represented by startIndex), the test should start at startIndex - 1.
            return Array((0..<startIndex!).reversed())
            
            // With a repeat count, test that once the first track has been reached (i.e. at the beginning of the sequence),
            // the sequence resumes from the end.
            
            // The test results should look like this:
            // startIndex - 1, startIndex - 2, ..., 0, n - 1, n - 2, ... 3, 2, 1, 0, n - 1, n - 2, ... where n is the size of the sequence.
            
        }, 10)
    }
    
    func testPrevious_repeatAll_shuffleOff_noPlayingTrack() {
        
        for size in [1, 2, 3, 5, 10, 100, 500, 1000, 5000, 10000] {
            
            initSequence(size, nil, .all, .off)
            
            // When no track is currently playing, nil should be returned, even with repeated calls.
            for _ in 1...10 {
                
                XCTAssertNil(sequence.previous())
                
                // Also ensure that the sequence is still not pointing to any particular element (i.e. no iteration)
                XCTAssertNil(sequence.curTrackIndex)
            }
        }
    }
    
    func testPrevious_repeatOff_shuffleOn_withPlayingTrack() {
        
        doTestPrevious_shuffleOn(.off, {(size: Int, startIndex: Int?) -> [Int?] in
            
            // When shuffle is on, the test will begin with the last element in the shuffle sequence selected.
            
            // The sequence of elements produced by calls to previous() should match the shuffle sequence array,
            // starting with its 2nd-last element (the last element cannot be visited by previous()).
            var previousIndices: [Int?] = sequence.shuffleSequence.sequence.prefix(size - 1).reversed()
            
            // Test that after the first track (i.e. at the beginning of the sequence), nil is returned, even with repeated calls.
            previousIndices += Array(repeating: nil, count: 10)
            
            return previousIndices
        })
    }
    
    func testPrevious_repeatOff_shuffleOn_noPlayingTrack() {
        
        for size in [1, 2, 3, 5, 10, 100, 500, 1000, 5000, 10000] {
            
            initSequence(size, nil, .off, .on)
            
            // When no track is currently playing, nil should be returned, even with repeated calls.
            for _ in 1...10 {
                
                XCTAssertNil(sequence.previous())
                
                // Also ensure that the sequence is still not pointing to any particular element (i.e. no iteration)
                XCTAssertNil(sequence.curTrackIndex)
            }
        }
    }
    
    func testPrevious_repeatAll_shuffleOn_withPlayingTrack() {
        
        doTestPrevious_shuffleOn(.all, {(size: Int, startIndex: Int?) -> [Int?] in
            
            // When shuffle is on, the test will begin with the last element in the shuffle sequence selected.
            
            // The sequence of elements produced by calls to previous() should match the shuffle sequence array,
            // starting with its 2nd-last element (the last element cannot be visited by previous()).
            var previousIndices: [Int?] = sequence.shuffleSequence.sequence.prefix(size - 1).reversed()
            
            // Test that after the first track (i.e. at the beginning of the sequence), nil is returned, even with repeated calls.
            
            // NOTE - Even though repeat = .all, the shuffle sequence cannot go back to the previous sequence (because it no longer exists),
            // so it will stop at the first element, as if repeat were off.
            
            previousIndices += Array(repeating: nil, count: 10)
            
            return previousIndices
            
        })
    }
    
    func testPrevious_repeatAll_shuffleOn_noPlayingTrack() {
        
        for size in [1, 2, 3, 5, 10, 100, 500, 1000, 5000, 10000] {
            
            initSequence(size, nil, .all, .on)
            
            // When no track is currently playing, nil should be returned, even with repeated calls.
            for _ in 1...10 {
                
                XCTAssertNil(sequence.previous())
                
                // Also ensure that the sequence is still not pointing to any particular element (i.e. no iteration)
                XCTAssertNil(sequence.curTrackIndex)
            }
        }
    }
    
    private func doTestPrevious_noShuffle(_ repeatMode: RepeatMode, _ expectedIndicesFunction: ExpectedIndicesFunction, _ repeatCount: Int = 0) {
        
        var randomSizes: [Int] = [1, 2, 3, 4]
        
        for _ in 1...100 {
            randomSizes.append(Int.random(in: 5...10000))
        }
        
        for size in randomSizes {
            
            var startIndices: Set<Int> = Set()
            
            // These 2 indices are essential for testing and should always be present.
            startIndices.insert(0)
            startIndices.insert(size - 1)
            
            // Select up to 10 other random indices for the test
            for _ in 1...min(size, 10) {
                startIndices.insert(size == 1 ? 0 : Int.random(in: 0..<size))
            }
            
            for startIndex in startIndices {
                
                initSequence(size, startIndex, repeatMode, .off)
                
                // Exercise the given indices function to obtain an array of expected results from repeated calls to previous().
                // NOTE - The size of the expectedIndices array will determine how many times previous() will be called (and tested).
                let expectedIndices: [Int?] = expectedIndicesFunction(size, startIndex)
                
                // For each expected index value, call previous() and match its return value.
                for expectedIndex in expectedIndices {
                    
                    // Capture the current sequence index before calling previous()
                    let indexBeforePrevious = sequence.curTrackIndex
                    
                    XCTAssertEqual(sequence.previous(), expectedIndex)
                    
                    // Also verify that,
                    // if previous() produced a non-nil value, the sequence is now pointing at this new value (i.e. iteration took place)
                    // OR
                    // if previous() produced nil, the sequence is pointing at the same value it was pointing to before the call to previous()
                    // (i.e. no iteration took place)
                    XCTAssertEqual(sequence.curTrackIndex, expectedIndex != nil ? expectedIndex : indexBeforePrevious)
                }
                
                // When repeatMode = .all, the sequence will be restarted the previous time subsequent() is called.
                // If a repeatCount is given, perform further testing by looping through the sequence again.
                if repeatCount > 0 && repeatMode == .all && size > 1 {
                    doTestPrevious_sequenceRestart_repeatAll_shuffleOff(repeatCount)
                }
            }
        }
    }
    
    private func doTestPrevious_shuffleOn(_ repeatMode: RepeatMode, _ expectedIndicesFunction: ExpectedIndicesFunction, _ repeatCount: Int = 0) {
        
        var randomSizes: [Int] = [1, 2, 3, 4]
        
        for _ in 1...100 {
            randomSizes.append(Int.random(in: 5...10000))
        }
        
        for size in randomSizes {
            
            let startIndex = Int.random(in: 0..<size)
            
            initSequence(size, startIndex, repeatMode, .on)
            
            // When shuffle is on, begin the test at the end of the sequence (otherwise, previous() cannot be tested).
            while sequence.peekNext() != nil {
                _ = sequence.next()
            }
            
            // Exercise the given indices function to obtain an array of expected results from repeated calls to previous().
            // NOTE - The size of the expectedIndices array will determine how many times previous() will be called (and tested).
            let expectedIndices: [Int?] = expectedIndicesFunction(size, startIndex)
            
            // For each expected index value, call previous() and match its return value.
            for expectedIndex in expectedIndices {
                
                // Capture the current sequence index before calling previous()
                let indexBeforePrevious = sequence.curTrackIndex
                
                XCTAssertEqual(sequence.previous(), expectedIndex)
                
                // Also verify that,
                // if previous() produced a non-nil value, the sequence is now pointing at this new value (i.e. iteration took place)
                // OR
                // if previous() produced nil, the sequence is pointing at the same value it was pointing to before the call to previous()
                // (i.e. no iteration took place)
                XCTAssertEqual(sequence.curTrackIndex, expectedIndex != nil ? expectedIndex : indexBeforePrevious)
            }
        }
    }
    
    // Loop around to the beginning of the sequence and iterate through it.
    private func doTestPrevious_sequenceRestart_repeatAll_shuffleOff(_ repeatCount: Int) {
        
        let reversedSequenceRange: [Int] = (0..<sequence.size).reversed()
        
        for _ in 1...repeatCount {
            
            // Iterate through the same sequence again, from the beginning, and verify that calls to previous()
            // produce the same sequence again.
            for value in reversedSequenceRange {
                
                XCTAssertEqual(sequence.previous(), value)
                
                // Also verify that the sequence is now pointing at this new value (i.e. iteration took place)
                XCTAssertEqual(sequence.curTrackIndex, value)
            }
        }
    }
    
    func testPrevious_repeatOff_shuffleOff_emptySequence() {
        doTestPrevious_emptySequence(.off, .off)
    }
    
    func testPrevious_repeatOne_shuffleOff_emptySequence() {
        doTestPrevious_emptySequence(.one, .off)
    }
    
    func testPrevious_repeatAll_shuffleOff_emptySequence() {
        doTestPrevious_emptySequence(.all, .off)
    }
    
    func testPrevious_repeatOff_shuffleOn_emptySequence() {
        doTestPrevious_emptySequence(.off, .on)
    }
    
    func testPrevious_repeatAll_shuffleOn_emptySequence() {
        doTestPrevious_emptySequence(.all, .on)
    }
    
    private func doTestPrevious_emptySequence(_ repeatMode: RepeatMode, _ shuffleMode: ShuffleMode) {
        
        // Create and verify an empty sequence.
        initSequence(0, nil, repeatMode, shuffleMode)
        
        XCTAssertEqual(sequence.size, 0)
        XCTAssertEqual(sequence.curTrackIndex, nil)
        
        // Repeated calls to previous() should all produce nil.
        for _ in 1...10 {
            
            XCTAssertNil(sequence.previous())
            
            // Ensure that no resizing/iteration has taken place.
            XCTAssertEqual(sequence.size, 0)
            XCTAssertEqual(sequence.curTrackIndex, nil)
        }
    }    
}
