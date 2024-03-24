import SwiftUI
import AVFoundation

@main
struct VLPlayerApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            PlaylistView()
        }
    }

    class AppDelegate: NSObject, UIApplicationDelegate {
        // swiftlint: disable:next line_length
      func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
          debugPrint(error)
        }
        return true
      }
    }
}
