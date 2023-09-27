//
//  WallpaperView.swift
//  Minepaper
//
//  Created by Timothy Lickteig on 9/24/23.
//

import SwiftUI

struct WallpaperView: View {
    
    var wallpaperOption: WallpaperOption
    var body: some View {
        VStack {
            NavigationStack {
                ScrollView {
                    VStack {
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            Image(uiImage: wallpaperOption.uiImage)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                                .padding()
                        }
                        else {
                            Image(uiImage: wallpaperOption.uiImage)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                                .padding()
                                .frame(width: 750)
                        }
                        
                        Spacer()
                        
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            Buttons(wallpaperOption: wallpaperOption)
                        }
                        else {
                            HStack {
                                Spacer()
                                Buttons(wallpaperOption: wallpaperOption)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct Buttons: View {
    
    var wallpaperOption: WallpaperOption
    
    var body: some View {
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
