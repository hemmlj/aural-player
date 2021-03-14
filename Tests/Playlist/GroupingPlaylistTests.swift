import XCTest

class GroupingPlaylistTests: AuralTestCase {
    
    var plst = GroupingPlaylist(.artists)
    
    func createNTracks(_ numTracks: Int, _ artist: String? = nil, _ album: String? = nil, _ genre: String? = nil) -> [Track] {
        
        var tracks: [Track] = []
        
        for counter in 1...numTracks {
            
            let title = "Track-" + String(counter)
            let theArtist = artist
            let theAlbum = album
            let theGenre = genre
        
            let track = Track(URL(fileURLWithPath: String(format: "/Dummy/%@.mp3", title)))
            track.setPrimaryMetadata(theArtist, title, theAlbum, theGenre, Double.random(in: 60...600))
            
            tracks.append(track)
        }
        
        return tracks
    }

    func testRemoveTracksAndGroups() {
        
        let madonnaTracks = createNTracks(5, "Madonna")
        let grimesTracks = createNTracks(2, "Grimes")
        let biosphereTracks = createNTracks(10, "Biosphere")
        
        for track in madonnaTracks + grimesTracks + biosphereTracks {
            _ = plst.addTrack(track)
        }
        
        XCTAssertEqual(plst.numberOfGroups, 3)
        
        let allGroups = plst.groups
        XCTAssertEqual(allGroups.count, 3)
        
        let madonnaGroup = allGroups.first(where: {$0.name == "Madonna"})!
        let grimesGroup = allGroups.first(where: {$0.name == "Grimes"})!
        let biosphereGroup = allGroups.first(where: {$0.name == "Biosphere"})!
        
        XCTAssertEqual(madonnaGroup.size, 5)
        XCTAssertEqual(grimesGroup.size, 2)
        XCTAssertEqual(biosphereGroup.size, 10)
        
        let groupsToRemove = [grimesGroup]
        let tracksToRemove = [madonnaTracks[1], madonnaTracks[3], biosphereTracks[4]]
        
        let results = plst.removeTracksAndGroups(tracksToRemove, groupsToRemove)
        XCTAssertFalse(plst.groups.contains(grimesGroup))
        XCTAssertEqual(madonnaGroup.size, 3)
        XCTAssertEqual(biosphereGroup.size, 9)
    }
}
