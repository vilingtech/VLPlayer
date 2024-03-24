import SwiftUI

struct PlaylistView: View {

    @StateObject var viewModel: PlaylistViewModel = PlaylistViewModel(repository: LocalPlaylistRepository())
    @State private var isShowingFilePicker = false
    @State private var selectedURLs: [URL] = []
    @State private var selectedSong: Song?
    @State private var isPresenting = false

    var body: some View {

        VStack {
            Spacer()
            NavigationStack {
                List(viewModel.songs) { song in
                    Button(action: {
                        selectedSong = song
                    }, label: { HStack {
                        Text(song.title)
                        Spacer()
                        Text(song.artist)
                            .foregroundColor(.gray)
                    }
                    })
                }
                .listStyle(.plain)
                .fullScreenCover(item: $selectedSong) { song in
                    PlayerControlsView(playerControlViewModel:
                                        PlayerControlViewModel(playlist: viewModel.songs, selectedSong: song))
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Playlist")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Clear") {
                            viewModel.clearList()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add") {
                            isShowingFilePicker.toggle()
                        }
                        .sheet(isPresented: $isShowingFilePicker) {
                            DocumentPickerView(selectedURLs: $selectedURLs)
                        }
                        .onChange(of: selectedURLs) { urls in
                            viewModel.importSongs(urls)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    PlaylistView()
}

#Preview("Chinese") {
    PlaylistView()
        .environment(\.locale, Locale(identifier: "zh-Hans"))
}
