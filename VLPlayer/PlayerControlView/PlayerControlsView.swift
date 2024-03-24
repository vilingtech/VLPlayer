import SwiftUI

struct PlayerControlsView: View {
    @ObservedObject var playerControlViewModel: PlayerControlViewModel
    @State private var currentTime: Double = 0
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "chevron.down")
                    .font(.system(size: 26))
                    .foregroundColor(Color.accent)
            })
            .padding(10)
            songImageView
            controlView
        }
        .onAppear {
            playerControlViewModel.isPlaying = true
        }
        .onDisappear {
            playerControlViewModel.isPlaying = false
        }
    }

    var songImageView: some View {
        Image("SongImage")
            .resizable()
            .scaledToFit()
            .cornerRadius(16)
    }

    var controlView: some View {
        VStack {
            Text(playerControlViewModel.songTitle)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(playerControlViewModel.songAlbum)
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            PlayerProgressBar(progress: $playerControlViewModel.progress,
                              duration: $playerControlViewModel.songDuration,
                              isDragging: $playerControlViewModel.isDragging) { position in
                playerControlViewModel.seekTo(position)
            }
            Spacer()
            PlayerControlBar(playerControlViewModel: playerControlViewModel, color: Color.accent)
            Spacer()
        }
        .padding(20)
    }
}

#Preview {
    // swiftlint: disable:next line_length
    let song = Song(title: "笑傲天涯", path: Bundle.main.url(forResource: "test", withExtension: "mp3")!.lastPathComponent, url: Bundle.main.url(forResource: "test", withExtension: "mp3")!, duration: 43, artist: "任賢齊", album: "一條龍")
    print(song)
    return PlayerControlsView(playerControlViewModel: PlayerControlViewModel(playlist: [song], selectedSong: song))
}
