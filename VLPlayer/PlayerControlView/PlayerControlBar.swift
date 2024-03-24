import SwiftUI

struct PlayerControlBar: View {

    @ObservedObject var playerControlViewModel: PlayerControlViewModel
    let color: Color

    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                playerControlViewModel.previous()
            }, label: {
                Image(systemName: "backward.fill")
                    .font(.system(size: 36))
                    .foregroundColor(color)
            })
            Spacer()
            Button(action: {
                playerControlViewModel.playPause()
            }, label: {
                Image(systemName: playerControlViewModel.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 36))
                    .foregroundColor(color)
            })
            Spacer()
            Button(action: {
                playerControlViewModel.next()
            }, label: {
                Image(systemName: "forward.fill")
                    .font(.system(size: 36))
                    .foregroundColor(color)
            })
            Spacer()
        }
    }
}

/*
 Spacer()
 Button(action: {
     playerControlViewModel.replay()
 }) {
     Image(systemName: "gobackward")
         .font(.system(size: 40))
         .foregroundColor(color)
 }
 Spacer()
 */
