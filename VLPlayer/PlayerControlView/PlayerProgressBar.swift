import SwiftUI

struct PlayerProgressBar: View {

    @Binding var progress: Double
    @Binding var duration: Double
    @Binding var isDragging: Bool

    @State private var currentPosition: Double = 0

    private(set) var backgroundColor = Color.gray
    private(set) var foregroundColor = Color.accent

    var onEndDragGesture: (Double) -> Void

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .opacity(0.3)
                        .foregroundColor(backgroundColor)
                    Rectangle()
                        .frame(width: min(geometry.size.width * progress, geometry.size.width),
                               height: geometry.size.height)
                        .foregroundColor(foregroundColor)
                }
                .gesture(DragGesture()
                    .onChanged({ value in
                        isDragging = true
                        self.progress = min(max(value.location.x / geometry.size.width, 0), 1)
                        self.currentPosition = self.duration * progress
                    })
                    .onEnded({ _ in
                        onEndDragGesture(currentPosition)
                    })
                )
            }
            .frame(height: 5)
            HStack {
                Text(formatTime(duration * progress))
                Spacer()
                Text(formatTime(duration))
            }.padding(.horizontal)
        }
    }

    private func formatTime(_ time: TimeInterval) -> String {
        guard !time.isNaN && !time.isInfinite else { return ""}
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        let formattedString = formatter.string(from: time) ?? "0:00"
        if formattedString.count < 2 {
            return "00:0\(formattedString)"
        } else if formattedString.count == 2 {
            return "0:\(formattedString)"
        } else {
            return formattedString
        }
    }
}
