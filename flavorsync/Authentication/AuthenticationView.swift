//
//  AuthenticationView.swift
//  flavorsync
//
//  Created by Aria Han on 7/9/24.
//

import SwiftUI

struct AuthenticationView: View {
    let colors: [Color] = [
        Color(hex: "38A169").opacity(0.6),
        Color(hex: "2D7A4A").opacity(0.6),
        Color(hex: "93DFA4").opacity(0.6),
        Color(hex: "76C893").opacity(0.6),
        Color.white.opacity(0.6)
    ]
    
    var body: some View {
        ZStack {
            // Background color
            Color(hex: "93DFA4")
                .edgesIgnoringSafeArea(.all)
            
            // Floating circles with alternating shades of green and white
            GeometryReader { geometry in
                ForEach(0..<20) { index in
                    Circle()
                        .fill(colors[index % colors.count])
                        .frame(width: CGFloat.random(in: 10...30), height: CGFloat.random(in: 10...30))
                        .position(x: CGFloat.random(in: 0...geometry.size.width),
                                  y: CGFloat.random(in: 0...geometry.size.height * 0.6)) // Limit to upper 60% of the screen
                }
            }
            
            VStack {
                Spacer()
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "4AC064"))
                            .frame(width: 200, height: 200)
                        Text("Flavorsync")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                Spacer()
                Text("Good food tastes better\nwhen it's shared.")
                    .font(.title3)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center) // Center align the text
                    .padding(.bottom, 50)
                HStack {
                    NavigationLink(destination: LoginView()) {
                        Text("Sign in")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "4AC064"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    NavigationLink(destination: RegistrationView()) {
                        Text("Register")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(Color(hex: "38A169"))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 50)
                .padding(.bottom, 50)
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(
            .sRGB,
            red: Double(r) / 0xff,
            green: Double(g) / 0xff,
            blue: Double(b) / 0xff,
            opacity: 1
        )
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
