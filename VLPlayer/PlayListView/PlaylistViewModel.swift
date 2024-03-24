import AVFoundation

class PlaylistViewModel: ObservableObject {

    @Published var songs: [Song] = []

    private var repository: PlaylistRepository
    private var player: AVPlayer?

    init(repository: PlaylistRepository) {
        self.repository = repository
        self.songs = repository.loadList()
    }

    @MainActor
    func importSongs(_ urls: [URL]) { // need to refactor for XCTest
        Task {
            let newSongs = await getSongs(from: urls)
            songs.append(contentsOf: newSongs)
            repository.saveList(songs)
            repository.saveFiles(urls)
        }
    }

    func clearList() {
        repository.clearList()
        self.songs = repository.loadList()
    }
}

// MARK: GET MUSIC INFOS
extension PlaylistViewModel {

    func getSongs(from urls: [URL]) async -> [Song] {
        do {
            let addSongs = try await fetchSongs(urls)
            return addSongs
        } catch {
            debugPrint(error)
        }
        return []
    }

    private func fetchSongs(_ urls: [URL]) async throws -> [Song] {
        try await withThrowingTaskGroup(of: Song.self) { group in
            urls.forEach { url in
                group.addTask { [unowned self] in
                    try await self.getSong(from: url)
                }
            }
            var result = [Song]()
            for try await song in group {
                result.append(song)
            }
            return result
        }
    }

    private func getSong(from url: URL) async throws -> Song {
        let asset = AVAsset(url: url)
        let metadata = try await asset.loadMetadata(for: AVMetadataFormat.id3Metadata)
        var title = "", artist = "", album = ""
        var imageData: Data?
        for item in metadata {
            if let commonKey = item.commonKey {
                switch commonKey {
                case .commonKeyTitle:
                    title = try await item.load(.stringValue) ?? ""
                case .commonKeyArtist:
                    artist = try await item.load(.stringValue) ?? ""
                case .commonKeyAlbumName:
                    album = try await item.load(.stringValue) ?? ""
                case .commonKeyArtwork:
                    imageData = try await item.load(.dataValue)
                default:
                    break
                }
            }
        }

        let duration = try await asset.load(.duration).seconds

        return Song(title: title,
                    path: url.lastPathComponent,
                    url: url, duration: duration,
                    artist: artist,
                    album: album,
                    imageData: imageData)
    }
}
