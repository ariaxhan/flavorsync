//
//  PreferencesView.swift
//  flavorsync
//
//  Created by Aria Han on 7/9/24.
//

import SwiftUI

struct PreferencesView: View {
    let preferences = ["Gluten-free", "Vegan", "Vegetarian", "Dairy-free", "Paleo", "Keto", "AIP", "Carnivore", "Nut-free"]
    let colors: [Color] = [.orange, .mint, .green, .blue, .green, .purple, .pink, .red, .yellow]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Preferences")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "magnifyingglass")
                    .padding(.trailing, 20)
            }
            .padding(.top, 60)
            
            Text("Select your food preferences, dietary restrictions, and anything else you can imagine")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.top, 10)
            
            SearchBar()
                .padding(.horizontal, 20)
                .padding(.top, 10)
            
            Spacer()
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(0..<preferences.count, id: \.self) { index in
                    Text(preferences[index])
                        .font(.headline)
                        .padding()
                        .frame(width: 100, height: 100)
                        .background(colors[index])
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            

        }
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.all)
    }
}

struct SearchBar: View {
    @State private var searchText = ""

    var body: some View {
        HStack {
            TextField("Search", text: $searchText)
                .padding(.leading, 24)
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(10)
        .overlay(
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 8)
            }
        )
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
