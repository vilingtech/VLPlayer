import XCTest
@testable import VLTPlayer

final class PlayListViewModelTests: XCTestCase {

    var viewModel: PlaylistViewModel!
    var repository: PlaylistRepositoryMock!

    lazy var importedSongs = {
        // swiftlint: disable:next line_length
        let song1 = Song(title: "Song one", path: "test.mp3", url: Bundle.main.url(forResource: "test", withExtension: "mp3")!, duration: 43, artist: "任賢齊", album: "一條龍")
        // swiftlint: disable:next line_length
        let song2 = Song(title: "Song two", path: "test.mp3", url: Bundle.main.url(forResource: "test", withExtension: "mp3")!, duration: 55, artist: "任賢齊", album: "一條龍")
        return [song1, song2]
    }()

    override func setUpWithError() throws {
        try super.setUpWithError()
        repository = PlaylistRepositoryMock()
        viewModel = PlaylistViewModel(repository: repository)
    }

    override func tearDownWithError() throws {
        repository = nil
        viewModel = nil
        try super.tearDownWithError()
    }

    func testInitialization() {
        XCTAssertEqual(viewModel.songs.count, 3, "Songs should be initialized with data from the repository")
        XCTAssertEqual(viewModel.songs[0].title, "Song one", "Initialized with data from the repository")
        XCTAssertEqual(viewModel.songs[1].title, "Song two", "Initialized with data from the repository")
        XCTAssertEqual(viewModel.songs[2].title, "Song three", "Initialized with data from the repository")
    }

    @MainActor func testGetSongs() async {
        let testBundle = Bundle(for: type(of: self))
        let url = testBundle.url(forResource: "test", withExtension: "mp3")!
        let song = await viewModel.getSongs(from: [url, url])
        XCTAssertEqual(song.count, 2, "only one song")
        XCTAssertGreaterThan(song[0].duration, 40, "the song with more than 40 seconde ")
    }

    func testClearList() {
        viewModel.clearList()
        XCTAssertEqual(viewModel.songs.count, 0, "No song after clean up ")
    }
}
