//
//  ContentView.swift
//  Minepaper
//
//  Created by Timothy Lickteig on 9/20/23.
//

import SwiftUI
import AsyncDownSamplingImage

struct ContentView: View {
    
    @State var images = [WallpaperOption]()
    @State var images2 = [String]()
    @State var isLoading = true
    @State private var size: CGSize = .init(width: 160, height: 90)
    
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
                                //Text(image)
                                /*AsyncImage(url: URL(string: image.)) { image in
                                 image.image?
                                 .resizable()
                                 .scaledToFill()
                                 
                                 }*/
                                let url = "https://cdn.minepaper.net/\(image)"
                                //LazyLoadedImage(url: url)
                                AsyncDownSamplingImage(url: URL(string: url), downsampleSize: size
                                ) { image in image
                                    .resizable()
                                    .scaledToFill()
                                    .padding(1)
                                    .cornerRadius(10)
                                } fail: { error in
                                  Text("Error loading image")
                                }
                                .cornerRadius(10)
                                .frame(width: 150)
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

/*
struct LazyLoadedImage: View {
    
    @State var initialImage = UIImage()
    @State var imageUrl: String
    
    init (url: String) {
        imageUrl = url
    }
    
    var body: some View {
        Image(uiImage: initialImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onAppear {
                let url = URL(string: imageUrl)
                URLSession.shared.dataTask(with: url!) { (data, response, error) in
                    guard let data = data else { return }
                    guard let image = UIImage(data: data) else { return }

                    RunLoop.main.perform {
                        self.initialImage = image
                    }

                }.resume()
            }
    }
}*/

#Preview {
    ContentView()
}
