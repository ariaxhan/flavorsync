import SwiftUI
import Firebase
import FirebaseAppCheck

@main
struct flavorsyncApp: App {
    
    init() {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Configure Firebase App Check
        if #available(iOS 14.0, *) {
            let providerFactory = AppAttestProviderFactory()
            AppCheck.setAppCheckProviderFactory(providerFactory)
        } else {
            print("App Attest is not available on this version of iOS")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}

@available(iOS 14.0, *)
class AppAttestProviderFactory: NSObject, AppCheckProviderFactory {
    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
        return AppAttestProvider(app: app)
    }
}
