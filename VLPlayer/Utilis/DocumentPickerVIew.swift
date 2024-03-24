import SwiftUI

struct DocumentPickerView: UIViewControllerRepresentable {

    typealias UIViewControllerType = UIDocumentPickerViewController

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio], asCopy: true)
        documentPicker.allowsMultipleSelection = true
        documentPicker.delegate = context.coordinator
        return documentPicker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    @Binding var selectedURLs: [URL]

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        selectedURLs = urls
        debugPrint("Document picker was cancelled. \(urls)")

    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        debugPrint("Document picker was cancelled.")
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
           var parent: DocumentPickerView

           init(parent: DocumentPickerView) {
               self.parent = parent
           }

           func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
               parent.selectedURLs = urls
           }

           func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
               debugPrint("Document picker was cancelled.")
           }
       }
}
