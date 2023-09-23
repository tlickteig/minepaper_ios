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
    //@State private var size: CGSize = .init(width: 384, height: 216)
    
    var body: some View {
        /*ScrollView {
            LazyVStack {
                ForEach(images, id: \.self) { image in
                    Text(image)
                }
            }
        }*/
        
        VStack {
            NavigationView {
                Form {
                    Section {
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
                            
                            /*List {
                                ForEach(images2, id: \.self) { image in
                                    LazyVStack {
                                        let url = "\(Constants.remoteImagesFolder)/\(image)"
                                        AsyncImage(url: URL(string: url)) { image in
                                            image.image?
                                                .resizable()
                                                .scaledToFill()
                                                
                                        }
                                    }
                                }
                            }*/
                        }
                        
                        if isLoading {
                            VStack {
                                ProgressView()
                                Text("Getting images...")
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    /*.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ value in
                            print("Hello World!")
                        }))*/
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
                        loadMoreImages()
                        /*for image in images {
                            let url = "\(Constants.remoteImagesFolder)/\(image)"
                            let view = AsyncDownSamplingImage(url: URL(string: url), downsampleSize: size
                            ) { precache in precache
                                
                            }
                            fail: { error in
                                
                            }
                        }*/
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
            
            for i in indexOfLastImageLoaded..<(indexOfLastImageLoaded + 20) {
                loadedImages.append(images[i])
            }
        }
        else {
            for i in 0..<(0 + 20) {
                loadedImages.append(images[i])
            }
        }
    }
}

#Preview {
    ContentView()
}
