//
//  ContentView.swift
//  Minepaper
//
//  Created by Timothy Lickteig on 9/20/23.
//

import SwiftUI
import AsyncDownSamplingImage

struct ContentView: View {
    
    @State var images = [String]()
    @State var isLoading = true
    @State private var size: CGSize = .init(width: 640, height: 360)
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    if !isLoading {
                        ScrollView {
                            LazyVStack {
                                ForEach(images, id: \.self) { image in
                                    let url = "https://cdn.minepaper.net/\(image)"
                                    AsyncDownSamplingImage(url: URL(string: url), downsampleSize: size
                                    ) { image in image
                                            .resizable()
                                            .scaledToFill()
                                            .padding(1)
                                            .cornerRadius(15)
                                    } fail: { error in
                                        Text("Error loading image")
                                    }
                                    .cornerRadius(15)
                                }
                            }
                        }
                    }
                    
                    if isLoading {
                        VStack {
                            ProgressView()
                            Text("Getting images...")
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .navigationTitle("Minepaper")
            }
            .task {
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        defer {
                            isLoading = false
                        }
                        
                        images = try Utilities.getImageListFromServer()
                    }
                    catch {
                        
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
