import AVFoundation

class MockAVPlayer: AVPlayer {
    var isPlayCalled = false
    var isPauseCalled = false
    var currentTime: CMTime = .zero
    var mockStatus: AVPlayer.Status = .unknown

    override var status: AVPlayer.Status {
        return mockStatus
    }
    var mockCurrentItem: AVPlayerItem?

    var mockDuration: CMTime = CMTimeMake(value: 55, timescale: 1)

    override var currentItem: AVPlayerItem? {
        return mockCurrentItem
    }

    override func play() {
        super.play()
        isPlayCalled = true
        mockStatus = .readyToPlay
        currentTime = CMTimeMake(value: 1, timescale: 1) // Simulate a non-zero playback time to indicate playing.
    }

    override func pause() {
        isPauseCalled = true
        // When pause is called, adjust the mock status or currentTime if necessary
        // to reflect the 'paused' state.
    }

    func simulateEndOfMedia() {
        currentTime = mockDuration
    }
}
