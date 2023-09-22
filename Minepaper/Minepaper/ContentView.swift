//
//  ContentView.swift
//  Minepaper
//
//  Created by Timothy Lickteig on 9/20/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var images = [WallpaperOption]()
    @State var images2 = [String]()
    @State var isLoading = true
    
    var body: some View {
        VStack {
            NavigationView {
                if !isLoading {
                    /*VStack {
                        List(images, id: \.id) { image in
                            AsyncImage(url: URL(string: image.fullImageUrl)) { image in
                                image.image?
                                    .resizable()
                                    .scaledToFill()
                                
                            }
                        }
                    }
                    .navigationTitle("Minepaper")*/
                    ScrollView {
                        LazyVStack {
                            ForEach(images2, id: \.self) { image in
                                Text(image)
                            }
                        }
                    }
                }
                
                if isLoading {
                    ProgressView()
                    Text("")
                    Text("Downloading images...")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .task {
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        defer {
                            isLoading = false
                        }
                        
                        let imageList = try Utilities.getImageListFromServer()
                        images2 = imageList
                        for image in imageList {
                            images.append(WallpaperOption(imageName: image))
                        }
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
