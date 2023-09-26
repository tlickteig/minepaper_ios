//
//  WallpaperView.swift
//  Minepaper
//
//  Created by Timothy Lickteig on 9/24/23.
//

import SwiftUI

struct WallpaperView: View {
    
    private var wallpaperOption: WallpaperOption
    
    init(image: WallpaperOption) {
        wallpaperOption = image
    }
    
    var body: some View {
        VStack {
            NavigationView {
                ScrollView {
                    VStack {
                        Image(uiImage: wallpaperOption.uiImage)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .padding()
                        Spacer()
                        
                        Button {
                            UIImageWriteToSavedPhotosAlbum(wallpaperOption.uiImage, nil, nil, nil)
                        } label: {
                            Label("Download Wallpaper", systemImage: "square.and.arrow.down")
                                .padding()
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                        
                        ShareLink(
                            item: wallpaperOption.image,
                            preview: SharePreview("Share Image", image: wallpaperOption.image)
                        ) {
                            Label("Share Wallpaper", systemImage: "square.and.arrow.up")
                                .padding()
                        }
                        .buttonStyle(.bordered)
                        .padding()
                        
                        Button {
                            if let url = URL(string: wallpaperOption.fullImageUrl), UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                            else {
                                
                            }
                        } label: {
                            Label("Open in Browser", systemImage: "globe")
                                .padding()
                        }
                        .buttonStyle(.bordered)
                        .padding()
                        
                        Spacer()
                    }
                }
            }
        }
    }
}
