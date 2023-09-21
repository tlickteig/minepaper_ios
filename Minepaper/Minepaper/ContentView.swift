//
//  ContentView.swift
//  Minepaper
//
//  Created by Timothy Lickteig on 9/20/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var images = [WallpaperOption]()
    @State var isLoading = true
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    List(images, id: \.id) { image in
                        Text(image.imageName)
                    }
                    .task {
                        DispatchQueue.global(qos: .userInitiated).async {
                            do {
                                defer {
                                    isLoading = false
                                }
                                
                                let imageList = try Utilities.getImageListFromServer()
                                for image in imageList {
                                    images.append(WallpaperOption(imageName: image))
                                }
                            }
                            catch {
                                
                            }
                        }
                    }
                    .opacity(isLoading ? 0 : 1)
                    
                    VStack {
                        ProgressView()
                        Text("")
                        Text("Downloading images...")
                    }
                    .opacity(isLoading ? 1 : 0)
                }.navigationTitle("Minepaper")
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
