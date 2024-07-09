import SwiftUI
import Firebase
import FirebaseAppCheck

 @main
    struct flavorsyncApp: App {
      // register app delegate for Firebase setup
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


      var body: some Scene {
        WindowGroup {
          NavigationView {
            ContentView()
          }
        }
      }
    }
