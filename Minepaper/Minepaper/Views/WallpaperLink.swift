//
//  WallpaperLink.swift
//  Minepaper
//
//  Created by Timothy Lickteig on 9/26/23.
//

import SwiftUI

struct WallpaperLink: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isLoading = true
    @State var hasErrorHappened = false
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
                        .font(.custom(MinecraftFonts.Regular, size: 20))
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            else if hasErrorHappened {
                VStack {
                    Image(systemName: "exclamationmark.circle").foregroundStyle(.red)
                    Text("Sorry, An error occurred")
                        .font(.custom(MinecraftFonts.Regular, size: 15))
                    Button("Retry") {
                        hasErrorHappened = false
                        isLoading = true
                        
                        DispatchQueue.global(qos: .userInitiated).async {
                            initialize()
                        }
                    }
                    .buttonStyle(.borderless)
                    .font(.custom(MinecraftFonts.Regular, size: 15))
                }
            }
            else {
                VStack {
                    if wallpaperOption != nil {
                        WallpaperView(wallpaperOption: wallpaperOption!)
                    }
                }
            }
        }
        .task {
            DispatchQueue.global(qos: .userInitiated).async {
                initialize()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func initialize() {
        do {
            defer {
                isLoading = false
            }
            
            let image = try Utilities.downloadImageFromServer(imageName: wallpaperName)
            wallpaperOption = WallpaperOption(imageName: wallpaperName, uiImage: image)
        }
        catch {
            hasErrorHappened = true
        }
    }
    
    //Heavily based off of https://stackoverflow.com/questions/56571349/custom-back-button-for-navigationviews-navigation-bar-in-swiftui
    var backButton : some View {
        VStack {
            if UIDevice.current.userInterfaceIdiom == .phone {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.accentColor)
                    Text("Go Back").font(.custom(MinecraftFonts.Regular, size: 20))
                }
            }
        }
    }
}
