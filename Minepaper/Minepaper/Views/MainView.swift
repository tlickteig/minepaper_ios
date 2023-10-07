//
//  ContentView.swift
//  Minepaper
//
//  Created by Timothy Lickteig on 9/20/23.
//

import SwiftUI
import AsyncDownSamplingImage

struct MainView: View {
    
    @State var images = [String]()
    @State var loadedImages = [String]()
    @State var isLoading = true
    @State var hasErrorOccured = false
    @State private var size: CGSize = .init(width: 640, height: 360)
    //@State private var columnVisibility = NavigationSplitViewVisibility.detailOnly
    //@StateObject private var selectedImageIpad: IpadImageSelector
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    ScrollView {
                        LazyVStack {
                            ForEach(loadedImages, id: \.self) { image in
                                Spacer()
                                let url = "\(Constants.remoteImagesFolder)/\(image)"
                                NavigationLink(destination: WallpaperLink(imageName: image)) {
                                    AsyncDownSamplingImage(url: URL(string: url), downsampleSize: size
                                    ) { image in image
                                            .resizable()
                                            .scaledToFit()
                                            .padding(1)
                                            .cornerRadius(15)
                                    } fail: { error in
                                        ExecuteCode {
                                            hasErrorOccured = true
                                        }
                                    }
                                    .onAppear {
                                        if image == loadedImages.last && !hasErrorOccured {
                                            loadMoreImages()
                                        }
                                    }
                                    .cornerRadius(15)
                                    .frame(height: 180)
                                }
                                .frame(width: 1000)
                                Spacer()
                            }
                        }
                    }
                    
                    if isLoading {
                        loadingView
                    }
                    
                    if hasErrorOccured {
                        errorOccurredView
                    }
                }
                .navigationBarTitleDisplayMode(.automatic)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        toolbarView
                    }
                }
                .padding()
                
                VStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180)
                    Text("Welcome to Minepaper!")
                        .font(.custom(MinecraftFonts.Regular, size: 60))
                    Text("Swipe from the left and select an image to view")
                        .font(.custom(MinecraftFonts.Regular, size: 30))
                }
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
            .task {
                DispatchQueue.global(qos: .userInitiated).async {
                    initialize()
                }
            }
        }
    }
    
    var loadingView: some View {
        VStack {
            ProgressView()
            Text("Getting images...")
                .font(.custom(MinecraftFonts.Regular, size: 15))
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var errorOccurredView: some View {
        VStack {
            Image(systemName: "exclamationmark.circle").foregroundStyle(.red)
            Text("Sorry, An error occurred")
                .font(.custom(MinecraftFonts.Regular, size: 15))
            Button("Retry") {
                hasErrorOccured = false
                DispatchQueue.global(qos: .userInitiated).async {
                    initialize()
                }
            }
            .buttonStyle(.borderless)
            .font(.custom(MinecraftFonts.Regular, size: 15))
        }
    }
    
    var toolbarView: some View {
        HStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 30)
            Text("Minepaper").font(.custom(MinecraftFonts.Regular, size: 20))
            Text("v\(Utilities.returnVersionName())")
                .foregroundStyle(.gray)
                .font(.custom(MinecraftFonts.Regular, size: 20))
        }
    }
    
    private func initialize() {
        do {
            defer {
                isLoading = false
            }
            
            images = try Utilities.getImageListFromServer()
            loadMoreImages()
        }
        catch {
            hasErrorOccured = true
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
