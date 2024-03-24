import AVFoundation
import Combine

class PlayerControlViewModel: ObservableObject {

    let playlist: [Song]
    var currentSongIndex = 0

    var player: AVPlayer?
    private var timeObserver: Any?
    private var cancellables: Set<AnyCancellable> = []

    @Published var isPlaying = false

    @Published var songTitle = ""
    @Published var songArtist = ""
    @Published var songAlbum = ""
    @Published var songDuration = 0.0
    @Published var songImageData: Data?

    @Published var progress: Double = 0.0
    @Published var isDragging = false
    @Published var isPlayerExpanded = false

    init(playlist: [Song], selectedSong: Song, player: AVPlayer? = nil) {
        self.playlist = playlist
        self.currentSongIndex = playlist.firstIndex(of: selectedSong) ?? 0
        self.player = player ?? AVPlayer()
        setupAudioPlayer()
    }

    deinit {
        removeTimeObserver()
        disableRemoteTransportControls()
        clearNowPlayingInfo()
        NotificationCenter.default.removeObserver(self)
    }

    private func setupNextSongNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(next),
                                               name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

    private func setupAudioPlayer() {
        guard currentSongIndex < playlist.count else {
            fatalError("Playlist is empty.")
        }
        let currentSong = playlist[currentSongIndex]
        let playerItem = AVPlayerItem(url: currentSong.url)

        songTitle = currentSong.title
        songArtist = currentSong.artist
        songAlbum = currentSong.album
        songDuration = currentSong.duration
        songImageData = currentSong.imageData
        player?.replaceCurrentItem(with: playerItem)

        addPeriodicTimeObserver()
        setupRemoteTransportControls()
        setupNextSongNotification()

        $isPlaying
            .sink { [weak self] isPlaying in
                isPlaying ? self?.player?.play() : self?.player?.pause()
            }
            .store(in: &cancellables)
    }

    private func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: 1)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let duration = self?.player?.currentItem?.duration.seconds else { return }
            guard !duration.isNaN && self?.isDragging == false else { return }
            self?.progress = time.seconds / duration
            self?.updateNowPlayingInfo()
        }
    }

    public func seekTo(_ delay: Double) {
        let delayTime = CMTime(seconds: delay, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.seek(to: delayTime) { [weak self] _ in
            self?.isDragging = false
            self?.isPlaying = true
        }
    }

    func seekToPosition(position: TimeInterval) {
        let newPosition = CMTime(seconds: position, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.seek(to: newPosition) { [weak self] _ in
            self?.updateNowPlayingInfo()
        }
    }

    private func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }

    func playPause() {
        isPlaying.toggle()
        updateNowPlayingInfo()
    }

    func stop() {
        isPlaying = false
        progress = 0
        player?.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
    }

    @objc func next() {
        guard currentSongIndex < playlist.count - 1 else {
            return
        }

        currentSongIndex += 1
        playSong(at: currentSongIndex)
    }

    func previous() {
        guard currentSongIndex > 0 else {
            return
        }

        currentSongIndex -= 1
        playSong(at: currentSongIndex)
    }

    func replay() {
        playSong(at: currentSongIndex)
    }

    private func playSong(at index: Int) {
        guard index >= 0 && index < playlist.count else {
            return
        }

        let song = playlist[index]
        songTitle = song.title
        songArtist = song.artist
        songAlbum = song.album
        songDuration = song.duration

        let playerItem = AVPlayerItem(url: song.url)
        player?.replaceCurrentItem(with: playerItem)
        progress = 0
        if isPlaying {
            player?.play()
        }
    }
}
