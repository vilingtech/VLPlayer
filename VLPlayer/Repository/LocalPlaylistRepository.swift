import Foundation

class LocalPlaylistRepository: PlaylistRepository {

    func saveFiles(_ urls: [URL]) {
        for url in urls {
            LocalFileManager.saveToDocumentDirectory(url)
        }
    }

    func saveList(_ playlist: [Song]) {

        UserDefaultManager.savePlaylist(playlist)
    }

    func loadList() -> [Song] {

        let songs = UserDefaultManager.loadPlaylist()
        let existedSongs = fetchExistedSongs(from: songs)
        return existedSongs

    }

    private func fetchExistedSongs(from playlist: [Song]) -> [Song] {
        var validSongs = [Song]()
        for song in playlist {
            if let url = LocalFileManager.getValidURL(song.path) {
                var validSong = song
                validSong.url = url
                validSongs.append(validSong)
            }
        }
        return validSongs
    }

    func clearList() {

        UserDefaultManager.clearPlaylist()
        LocalFileManager.clearFiles()

    }

}

// TODO: Refactor codes

private struct UserDefaultManager {

    private static let playlistKey = "Playlist"

    static func clearPlaylist() {

        UserDefaults.standard.removeObject(forKey: playlistKey)
    }

    static func savePlaylist(_ playlist: [Song]) {

        let data = try? JSONEncoder().encode(playlist)
        UserDefaults.standard.set(data, forKey: playlistKey)
    }

    static func loadPlaylist() -> [Song] {

        guard let data = UserDefaults.standard.data(forKey: playlistKey),
              let playlist = try? JSONDecoder().decode([Song].self, from: data) else {
            return []
        }
        return playlist
    }
}

private struct LocalFileManager {

    static func saveToDocumentDirectory(_ url: URL) {

        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let destinationURL = documentDirectory.appendingPathComponent(url.lastPathComponent)
        do {
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            try fileManager.copyItem(at: url, to: destinationURL)
            debugPrint("File copied to: \(destinationURL)")
        } catch {
            debugPrint("Error copying file: \(error)")
            return
        }
        return
    }

    static func clearFiles() {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                try fileManager.removeItem(at: fileURL)
            }
            debugPrint("Successfully cleared all files in the folder.")
        } catch {
            debugPrint("Error clearing files in the folder: \(error)")
        }
    }

    static func getValidURL(_ lastPath: String) -> URL? {

        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let validURL = documentDirectory.appendingPathComponent(lastPath)
        guard fileManager.fileExists(atPath: validURL.relativePath) else {
            return nil
        }
        return validURL
    }

}
