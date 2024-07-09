//
//  ContentView.swift
//  blossom
//
//  Created by Aria Han on 6/16/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                AuthenticationFlowView(showSignInView: $showSignInView) // Show AuthenticationFlowView directly
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
                AuthenticationView()
            }
        }
        .animation(.easeInOut, value: showSignInView)
    }
}

#Preview {
    ContentView()
}
