import Foundation
import XCTest

class PlaylistRepositoryMock: PlaylistRepository {

    private var isEmptyList = false

    private var localSongs = {
        // swiftlint: disable:next line_length
        let song1 = Song(title: "Song one", path: Bundle.main.url(forResource: "test", withExtension: "mp3")!.lastPathComponent, url: Bundle.main.url(forResource: "test", withExtension: "mp3")!, duration: 43, artist: "任賢齊", album: "一條龍")
        // swiftlint: disable:next line_length
        let song2 = Song(title: "Song two", path: Bundle.main.url(forResource: "test", withExtension: "mp3")!.lastPathComponent, url: Bundle.main.url(forResource: "test", withExtension: "mp3")!, duration: 55, artist: "任賢齊", album: "一條龍")
        // swiftlint: disable:next line_length
        let song3 = Song(title: "Song three", path: Bundle.main.url(forResource: "test", withExtension: "mp3")!.lastPathComponent, url: Bundle.main.url(forResource: "test", withExtension: "mp3")!, duration: 100, artist: "任賢齊", album: "一條龍")
        return [song1, song2, song3]
    }()

    func saveFiles(_ urls: [URL]) {
    }

    func saveList(_ playlist: [Song]) {
        localSongs = playlist
    }

    func loadList() -> [Song] {
        return localSongs
    }

    private func fetchExistedSongs(from playlist: [Song]) -> [Song] {
        []
    }

     func clearList() {
        localSongs = []
    }

}
