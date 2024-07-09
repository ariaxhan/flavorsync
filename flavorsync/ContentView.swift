import SwiftUI

struct ContentView: View {
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                AuthenticationFlowView(showSignInView: $showSignInView)
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
    }
}

struct AuthenticationFlowView: View {
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            if showSignInView {
                AuthenticationView()
            } else {
                PreferencesView()
            }
        }
        .animation(.easeInOut, value: showSignInView)
    }
}

#Preview {
    ContentView()
}
