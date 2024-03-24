import Foundation

struct Song: Codable, Identifiable, Equatable {

    var id = UUID()
    let title: String
    let path: String
    var url: URL
    let duration: Double
    let artist: String
    let album: String
    var imageData: Data?
}
