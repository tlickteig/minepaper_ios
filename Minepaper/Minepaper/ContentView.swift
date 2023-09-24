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
    @State var loadedImages = [String]()
    @State var isLoading = true
    @State private var size: CGSize = .init(width: 640, height: 360)
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    if !isLoading {
                        ScrollView {
                            LazyVStack {
                                ForEach(loadedImages, id: \.self) { image in
                                    Spacer()
                                    let url = "\(Constants.remoteImagesFolder)/\(image)"
                                    NavigationLink(destination: WallpaperView(image: image)) {
                                        AsyncDownSamplingImage(url: URL(string: url), downsampleSize: size
                                        ) { image in image
                                                .resizable()
                                                .scaledToFit()
                                                .padding(1)
                                                .cornerRadius(15)
                                        } fail: { error in
                                            Text("Error loading image")
                                        }
                                        .onAppear {
                                            if image == loadedImages.last {
                                                loadMoreImages()
                                            }
                                        }
                                        .cornerRadius(15)
                                        .frame(height: 180)
                                    }
                                    Spacer()
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
                .padding()
            }
            .task {
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        defer {
                            isLoading = false
                        }
                        
                        images = try Utilities.getImageListFromServer()
                        loadMoreImages()
                    }
                    catch {
                        
                    }
                }
            }
        }
    }
    
    private func loadMoreImages() {
        if !loadedImages.isEmpty {
            let lastImageLoaded = loadedImages.last ?? ""
            let indexOfLastImageLoaded = images.lastIndex(of: lastImageLoaded) ?? 0
            let indexToStartAt = indexOfLastImageLoaded + 1
            
            for i in indexToStartAt..<(indexToStartAt + 5) {
                if i < images.count {
                    loadedImages.append(images[i])
                }
            }
        }
        else {
            for i in 0..<(0 + 5) {
                loadedImages.append(images[i])
            }
        }
    }
}
