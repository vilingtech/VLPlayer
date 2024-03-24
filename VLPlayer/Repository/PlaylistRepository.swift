import Foundation

protocol PlaylistRepository {

    func saveList(_ playlist: [Song])
    func loadList() -> [Song]
    func clearList()
    func saveFiles(_ urls: [URL])

}
