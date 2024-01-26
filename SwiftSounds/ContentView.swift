//
//  ContentView.swift
//  SwiftSounds
//
//  Created by charlene hoareau on 26/01/2024.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
    
}

struct ContentView: View {
    @State private var results = [Result]()
    @State private var username = ""
    @State private var email = ""
    
    var disableForm: Bool {
        username.count < 5 || email.count < 5
    }
    
    
    var body: some View {
            VStack {
                //Image
                AsyncImage(url: URL(string: "https://cache.umusic.com/_sites/_halo/zrskt/nwff/th/tetevonm.jpg")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                    } else if phase.error != nil {
                        Text("There was an error loading the image.")
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 200, height: 300)
                
                //Title
                Text("SwiftSounds")
                    .font(.title)
                    .padding()
                
                //Liste des musiques de Taylor Swift
                List(results, id: \.trackId) { item in
                    VStack(alignment: .leading) {
                        Text(item.trackName)
                            .font(.headline)
                        
                        Text(item.collectionName)
                            .font(.headline)
                    }
                }
                .task {
                    await loadData()
                }
            }
        }
        
        func loadData() async {
            guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
                print("Invalid URL")
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data)
                {
                    results = decodedResponse.results
                }
                
            } catch {
                print("Invalid data")
            }
        }
    }

#Preview {
    ContentView()
}
