import XCTest
import AVFoundation

final class PlayerControlViewModelTests: XCTestCase {

    var viewModel: PlayerControlViewModel!
    var mockPlayer: MockAVPlayer!

    override func setUp() {
        super.setUp()
        // swiftlint: disable:next line_length
        let song1 = Song(title: "Song one", path: Bundle.main.url(forResource: "test", withExtension: "mp3")!.lastPathComponent, url: Bundle.main.url(forResource: "test", withExtension: "mp3")!, duration: 43, artist: "Riche Jean", album: "Lucky One")
        // swiftlint: disable:next line_length
        let song2 = Song(title: "Song two", path: Bundle.main.url(forResource: "test", withExtension: "mp3")!.lastPathComponent, url: Bundle.main.url(forResource: "test", withExtension: "mp3")!, duration: 55, artist: "Riche Jean", album: "Happy One")
        // swiftlint: disable:next line_length
        let song3 = Song(title: "Song three", path: Bundle.main.url(forResource: "test", withExtension: "mp3")!.lastPathComponent, url: Bundle.main.url(forResource: "test", withExtension: "mp3")!, duration: 55, artist: "Riche Jean", album: "Happy One")

        mockPlayer = MockAVPlayer(playerItem: AVPlayerItem(url: song2.url))
        viewModel = PlayerControlViewModel(playlist: [song1, song2, song3], selectedSong: song2,
                                           player: mockPlayer)
    }

    override func tearDown() {
        viewModel = nil
        mockPlayer = nil
        super.tearDown()
    }

    func testInitialization() {
        XCTAssertEqual(viewModel.currentSongIndex, 1)
        XCTAssertEqual(viewModel.songTitle, "Song two")
        XCTAssertEqual(viewModel.songArtist, "Riche Jean")
        XCTAssertEqual(viewModel.songAlbum, "Happy One")
        XCTAssertEqual(viewModel.songDuration, 55)
    }

    func testPlayAndPause() {

        XCTAssertTrue(mockPlayer.isPauseCalled)
        XCTAssertFalse(mockPlayer.isPlayCalled)
        XCTAssertFalse(viewModel.isPlaying)

        viewModel.playPause()
        XCTAssertTrue(mockPlayer.isPlayCalled)
        XCTAssertTrue(viewModel.isPlaying)

        viewModel.playPause()
        XCTAssertFalse(viewModel.isPlaying)
    }

    func testSkipNext() {
        viewModel.next()
        XCTAssertEqual(viewModel.currentSongIndex, 2)
        viewModel.next()
        XCTAssertEqual(viewModel.currentSongIndex, 2)
    }

    func testSkipPrevious() {
        viewModel.previous()
        XCTAssertEqual(viewModel.currentSongIndex, 0)
        viewModel.previous()
        XCTAssertEqual(viewModel.currentSongIndex, 0)
    }

    func testMetadataUpdateOnSongChange() {
        viewModel.previous()
        XCTAssertEqual(viewModel.songTitle, "Song one")
        viewModel.next()
        XCTAssertEqual(viewModel.songTitle, "Song two")
        viewModel.next()
        XCTAssertEqual(viewModel.songTitle, "Song three")
    }
}
