//
//  WallpaperLink.swift
//  Minepaper
//
//  Created by Timothy Lickteig on 9/26/23.
//

import SwiftUI

struct WallpaperLink: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var orientation = UIDevice.current.orientation
    @State var isLoading = true
    @State var wallpaperOption: WallpaperOption?
    private var wallpaperName: String
    
    init(imageName: String) {
        wallpaperName = imageName
    }
    
    var body: some View {
        VStack {
            if isLoading {
                VStack {
                    ProgressView()
                    Text("Loading...")
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            else {
                VStack {
                    WallpaperView(wallpaperOption: wallpaperOption!)
                }
            }
        }
        .task {
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    defer {
                        isLoading = false
                    }
                    
                    let image = try Utilities.downloadImageFromServer(imageName: wallpaperName)
                    wallpaperOption = WallpaperOption(imageName: wallpaperName, uiImage: image)
                }
                catch {
                    
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    //Heavily based off of https://stackoverflow.com/questions/56571349/custom-back-button-for-navigationviews-navigation-bar-in-swiftui
    var backButton : some View {
        VStack {
            if shouldBackButtonBeVisible() {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left") // set image here
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.accentColor)
                    Text("Go Back")
                }
            }
        }
        .detectOrientation($orientation)
    }
    
    func shouldBackButtonBeVisible() -> Bool {
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        return !isIpad || (orientation.isPortrait || orientation.isFlat)
    }
}
